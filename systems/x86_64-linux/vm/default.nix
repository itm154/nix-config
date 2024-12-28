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

  cli = {
    zsh.enable = true;
  };

  system = {
    secureBoot = {
      enable = true;
    };

    fonts = {
      enable = true;
      extraFonts = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
  ];

  system.stateVersion = "24.05";
}
