{pkgs, ...}: {
  programs.wezterm = {
    enable = false;
    package = pkgs.unstable.wezterm;
    extraConfig = ''
      local wezterm = require("wezterm")

      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.color_scheme = "Catppuccin Mocha"
      config.font = wezterm.font("JetBrainsMono Nerd Font")
      config.font_size = 16
      config.warn_about_missing_glyphs = false

      config.tab_bar_at_bottom = true
      config.window_frame = {
        font = wezterm.font("JetBrainsMono Nerd Font"),
        font_size = 12,
        active_titlebar_bg = "#181825",
        inactive_titlebar_bg = "#181825",
      }

      config.hide_tab_bar_if_only_one_tab = true
      config.colors = {
        tab_bar = {
          active_tab = {
            fg_color = "#CDD6F4",
            bg_color = "#313244",
          },
          inactive_tab = {
            fg_color = "#A6ADC8",
            bg_color = "#1E1E2E",
          },
          inactive_tab_hover = {
            fg_color = "#CDD6F4",
            bg_color = "#45475A",
          },
          new_tab = {
            fg_color = "#A6ADC8",
            bg_color = "#181825",
          },
          new_tab_hover = {
            fg_color = "#A6ADC8",
            bg_color = "#45475A",
          },
          inactive_tab_edge = "#1E1E2E",
        },
      }

      config.window_padding = {
        left = 2,
        right = 2,
        top = 2,
        bottom = 2,
      }

      config.keys = {
        {
          key = "T",
          mods = "CTRL|SHIFT",
          action = wezterm.action.SpawnTab("DefaultDomain"),
        },
        {
          key = "J",
          mods = "CTRL|SHIFT",
          action = wezterm.action.ActivateTabRelative(-1),
        },
        {
          key = "K",
          mods = "CTRL|SHIFT",
          action = wezterm.action.ActivateTabRelative(1),
        },
      }

      return config
    '';
  };
}
