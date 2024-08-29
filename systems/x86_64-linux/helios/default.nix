{
  config,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  imports = [
    ./hardware-configuration.nix
  ];

  desktop.plasma = {
    enable = true;
    x11 = true;
  };

  hardware = {
    audio.enable = true;
    batteryOptimization.enable = true;
    bluetooth.enable = true;
    networking.enable = true;
    nvidia = {
      enable = true;
      intelBusId = "PCI:1:0:0";
      nvidiaBusId = "PCI:0:2:0";
    };
  };

  services = {
    ime = {
      enable = true;
      extraModules = [pkgs.fcitx5-mozc]; # Japansese ime
    };
    powerButton.enable = true;
  };

  system = {
    flatpak.enable = true;
    secureBoot = {
      enable = true;
      entries = 5;
    };

    fonts = {
      enable = true;
      extraFonts = with pkgs; [
        (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
