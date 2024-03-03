{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.rust-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {allowUnfree = true;};
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry =
    (lib.mapAttrs (_: flake: {inherit flake;}))
    ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  # User config
  programs.fish.enable = true;
  programs.adb.enable = true;
  users.users = {
    itm154 = {
      initialPassword = "1234";
      isNormalUser = true;
      extraGroups = ["adbusers" "wheel" "networkmanager" "podman"];
      shell = pkgs.fish;
    };
  };

  # Enable flakes and new 'nix' command
  # Deduplicate and optimize nix store
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # Essential system config
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  # Internet
  networking = {
    hostName = "asus-nix";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    firewall = {
      enable = true;
      # 53317 for Localsend
      allowedTCPPorts = [80 443 53317];
      allowedUDPPortRanges = [
        {
          from = 4000;
          to = 4007;
        }
        {
          from = 53315;
          to = 53318;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
    };
  };

  # Display manager
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.theme = "rose-pine";
    libinput.enable = true;
    layout = "us";
    xkbVariant = "";
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Locales and input
  time.timeZone = "Asia/Kuching";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8"];
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

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk];
  };
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  # Enable flatpak and keyring
  services = {
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
  };

  services.printing.enable = true;
  services.printing.drivers = [pkgs.gutenprint];

  services.dbus.enable = true;
  security.pam.services = {
    sddm.enableGnomeKeyring = true;
    # swaylock = {};
  };

  security.polkit.enable = true;
  systemd = {
    user = {
      services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
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

  # Window manager
  programs.hyprland.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Wayland fixes
  environment.sessionVariables = {WLR_NO_HARDWARE_CURSORS = "1";};

  # Enables trash bin in nautilus
  services.gvfs.enable = true;

  # Prevent shutdown with short press
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  # Driver for drawing tablets
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    alsa-utils
    arion
    brightnessctl
    cava
    docker-client
    evince
    eza
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
    kitty
    libnotify
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
    wineWowPackages.stable
    wl-clipboard

    # Unstable packages
    unstable.wezterm
    unstable.xwaylandvideobridge
  ];

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    source-sans
    source-serif
    source-han-sans
    source-han-mono
    source-han-serif
    corefonts
  ];

  ### OTHER CONFIGS ###
  # Docker
  virtualisation.docker.enable = false;
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  # Fixes issues with fonts not appearing
  system.fsPackages = [pkgs.bindfs];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = ["/share/fonts"];
    };
    aggregatedIcons = pkgs.buildEnv {
      name = "system-icons";
      paths = with pkgs; [
        gnome.gnome-themes-extra
        bibata-cursors
      ];
      pathsToLink = ["/share/icons"];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
    "/usr/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
