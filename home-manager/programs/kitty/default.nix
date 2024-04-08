{...}: {
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
    theme = "Catppuccin-Mocha";
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 16;
    };
    settings = {
      enable_audio_bell = false;
      tab_bar_min_tabs = 2;
      tab_bar_edge = "bottom";
      tab_bar_style = "fade";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };
    keybindings = {
      "kitty_mod+k" = "next_tab";
      "kitty_mod+j" = "previous_tab";
      "kitty_mod+t" = "launch --type=tab --cwd=current";
      "kitty_mod+q" = "close_tab";
      "cmd+w" = "close_tab";
    };
  };
}
