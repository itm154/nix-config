{
  config,
  pkgs,
  ...
}: {
  programs.btop.enable = true;
  programs.btop.settings = {
    color_theme = "/home/itm154/.config/btop/themes/catppuccin_mocha.theme";
    theme_background = false;
  };

  home.file.".config/btop/themes" = {
    source = ./themes;
    recursive = true;
  };
}
