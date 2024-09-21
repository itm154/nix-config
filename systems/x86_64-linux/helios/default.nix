{
  config,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  imports = [
    ./hardware-configuration.nix
  ];

  apps = {
    steam.enable = true;
  };

  cli = {
    fish.enable = true;
  };

  desktop = {
    plasma = {
      enable = true;
      extraPackages = [pkgs.custom.klassy];
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
    flatpak = {
      enable = true;
      fixIcons = true;
    };
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

  # GPU Passthrough works but looking glass likes to complain about host application not running, so its basically unusable for gaming
  # Note that gpu gaming might not work because gpu drivers are effed up
  # virtualisation.kvm = {
  #   enable = true;
  #
  #   # NOTE: lspci -nn
  #   # 0000:01:00.0 VGA compatible controller [0300]: NVIDIA Corporation AD107M [GeForce RTX 4050 Max-Q / Mobile] [10de:28e1] (rev a1)
  #   # 0000:01:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:22be] (rev a1)
  #   vfioIds = ["10de:28e1" "10de:22be"];
  #
  #   # NOTE: Use `machinectl` and then `machinectl status <name>` to
  #   # get the unit "*.scope" of the virtual machine.
  #   machineUnits = ["machine-qemu\x2d4\x2dwin11.scope"];
  # };

  environment.systemPackages = with pkgs; [
    firefox
  ];

  # WARNING: This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
