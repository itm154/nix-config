{ config, pkgs, ... }: {
  programs.btop.enable = true;
  programs.btop.settings = {
    theme_background = false;
  };

  home.file.".config/btop/themes" = {
    source = ./themes;
    recursive = true;
  };
}
