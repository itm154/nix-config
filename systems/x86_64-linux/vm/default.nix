{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  desktop.plasma = {
    enable = true;
    x11 = true;
  };

  hardware = {
    audio.enable = true;
    networking.enable = true;
  };

  system = {
    secureBoot = {
      enable = true;
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

  system.stateVersion = "24.05";
}
