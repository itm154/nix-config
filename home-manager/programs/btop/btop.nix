{ config, pkgs, ... }: {
  programs.btop.enable = true;
  programs.btop.settings = {
    color_theme = "$HOME/.config/btop/themes/catppuccin_mocha.theme";
    theme_background = true;
  };

  home.file.".config/btop/themes" = {
    source = ./themes;
    recursive = true;
  };
}
