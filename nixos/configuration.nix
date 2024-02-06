{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      inputs.rust-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = { allowUnfree = true; };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; }))
    ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/path/${name}";
    value.source = value.flake;
  }) config.nix.registry;

  # Enable flakes and new 'nix' command
  # Deduplicate and optimize nix store
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  networking = {
    hostName = "asus-nix";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  # User config
  users.users = {
    itm154 = {
      initialPassword = "1234";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.fish;
    };
  };

  # Locales
  time.timeZone = "Asia/Kuching";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  # Weeaboo input method
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
  };

  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  # Display manager
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.theme = "rose-pine";

    # HID Devices
    libinput.enable = true;
    layout = "us";
    xkbVariant = "";
  };

  # Essential services
  services = {
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
  };

  # Prevent shutdown with short press
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  xdg.portal.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  # Securities
  security.pam.services = {
    sddm.enableGnomeKeyring = true;
    # swaylock = {};
  };

  # Gnome polkit
  security.polkit.enable = true;
  systemd = {
    user = {
      services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart =
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      extraConfig = ''
        DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
      '';
    };
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Wayland fixes
  environment.sessionVariables = { WLR_NO_HARDWARE_CURSORS = "1"; };

  # Driver for drawing tablets
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  # Basic system packages
  environment.systemPackages = with pkgs; [
    alsa-utils
    brightnessctl
    cava
    evince
    firefox
    gcc_multi
    gnome.file-roller
    gnome.gnome-calculator
    gnome.gnome-disk-utility
    gnome.gnome-font-viewer
    gnome.gnome-maps
    gnome.nautilus
    gnome.totem
    grimblast
    libsForQt5.kate
    kitty
    libnotify
    libsForQt5.print-manager
    loupe
    networkmanagerapplet
    pamixer
    pavucontrol
    playerctl
    procps
    rofi-wayland
    rust-bin.stable.latest.default
    sddm-rose-pine
    snapshot
    swaynotificationcenter
    swww
    vim
    waybar
    wezterm
    wl-clipboard
  ];

  programs.fish.enable = true;
  
  # Window manager
  programs.hyprland.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
