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

  desktop.addons.xdgPortal.enable = true;

  hardware = {
    audio.enable = true;
    networking.enable = true;
  };

  system = {
    boot = {
      enable = true;
    };

    fonts = {
      enable = true;
      extraFonts = with pkgs; [
        (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
      ];
    };
  };

  system.stateVersion = "24.05";

  environment.systemPackages = with pkgs; [
    firefox
  ];
}
