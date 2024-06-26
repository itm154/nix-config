{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Hardware modules
    outputs.nixosModules.nvidia
    outputs.nixosModules.battery-optimizations
    outputs.nixosModules.tablets

    # Software modules
    outputs.nixosModules.icons-fix
    outputs.nixosModules.input-method-editor
    # outputs.nixosModules.gdm
    outputs.nixosModules.gnome-utils
    outputs.nixosModules.gnome-apps
    outputs.nixosModules.core
    outputs.nixosModules.core-fonts
    outputs.nixosModules.wayland-core
    outputs.nixosModules.networking
    outputs.nixosModules.nix-helper
    outputs.nixosModules.sddm

    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # Custom overlays
      inputs.rust-overlay.overlays.default
    ];
    config = {allowUnfree = true;};
  };

  # ===============User config==============
  users.users = {
    itm154 = {
      initialPassword = "1234";
      isNormalUser = true;
      extraGroups = ["adbusers" "wheel" "networkmanager"];
      shell = pkgs.fish;
    };
  };
  # ========================================

  # ================Programs================
  programs.hyprland.enable = true;
  programs.fish.enable = true;
  programs.adb.enable = true;

  # Custom modules
  programs.gnome-apps.enable = true;
  # =======================================

  # ===============Services================
  services.flatpak.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [pkgs.gutenprint];

  # Custom service modules
  services.gnome-utils.enable = true;
  # =======================================

  # ===============Modules=================
  # NixOs stock modules
  hardware.bluetooth.enable = true;

  # Software related modules
  software.core.enable = true; # IMPORTANT
  software.icons-fix.enable = true;
  software.input-method-editor.enable = true;
  software.core-fonts.enable = true;
  software.wayland-core.enable = true;
  software.nix-helper = {
    enable = true;
    flake-dir = "/home/itm154/Repository/nix-config";
  };
  software.networking = {
    enable = true;
    hostName = "vivobook-nix";
  };
  software.sddm.enable = true;
  # software.gdm.enable = false;

  # Hardware related modules
  hardware.battery-optimizations.enable = true;
  hardware.nvidia.enable = true;
  hardware.tablets.enable = true;
  # ======================================

  # ===========System Packages============
  environment.systemPackages = with pkgs; [
    alsa-utils
    arion
    brightnessctl
    cava
    evince
    eza
    firefox
    gcc_multi
    grimblast
    kitty
    libnotify
    loupe
    networkmanagerapplet
    pamixer
    pavucontrol
    playerctl
    procps
    ripgrep
    rofi-wayland
    rust-bin.stable.latest.default
    scrcpy
    snapshot
    swaynotificationcenter
    swww
    vim
    waybar
    wineWowPackages.stable
    wl-clipboard
    xwaylandvideobridge
  ];
  # ======================================

  # ============DO NOT CHANGE=============
  system.stateVersion = "24.05";
  # ======================================

  # ==============Boilerplate=============
  nix.registry =
    (lib.mapAttrs (_: flake: {inherit flake;}))
    ((lib.filterAttrs (_: lib.isType "flake")) inputs);
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  # ======================================
}
