{...}: {
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "/home/itm154/.config/btop/themes/catppuccin_mocha.theme";
      theme_background = false;
      vim_keys = true;
    };
  };

  home.file.".config/btop/themes" = {
    source = ./themes;
    recursive = true;
  };
}
