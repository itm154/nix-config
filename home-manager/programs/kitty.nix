{ config, pkgs, ...}: {
  programs.kitty.enable = true;
  programs.kitty.shellIntegration = {
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.kitty.themes = "Catppuccin-Mocha";

  programs.kitty.font = {
    name = "JetBrains Mono Nerd Font";
    size = 16;
  };

  programs.kitty.settings = {
    enable_audio_bell = false;
    tab_bar_min_tabs = 2;
    tab_bar_edge = "bottom";
    tab_bar_style = "fade";
    tab_powerline_style = "slanted";
    tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
  };

  programs.kitty.keybindings = {
    "kitty_mod+k" = "next_tab";
    "kitty_mod+j" = "previous_tab";
    "kitty_mod+t" = "new_tab";
    "kitty_mod+q" = "close_tab";
    "cmd+w" = "close_tab";
  };
}
  
