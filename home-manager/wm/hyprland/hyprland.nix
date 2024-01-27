{ config, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$shiftMod" = "SUPERSHIFT";
      "$ctrlMod" = "SUPERCTRL";

      # Keybindings
      bind = [
        # Applications
        "$mainMod, Return, exec, wezterm"
        "$mainMod, B, exec, firefox"

        # Scripts
        "$shiftmod, S, exec, grimblast --notify copysave area $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')"
        "$shiftmod , A, exec, grimblast --notify copysave screen $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')"
        # $mainMod, D, exec, $HOME/.config/rofi/launchers/type-2/launcher.sh
        # $mainMod, X, exec, $HOME/.config/rofi/powermenu/type-2/powermenu.sh

        # Device controls
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "$mainMod, XF86AudioRaiseVolume, exec, brightnessctl set 5%+"
        "$mainMod, XF86AudioLowerVolume, exec, brightnessctl set 5%-"

        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pactl set-sink-mute 0 toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        "$mainMod, SPACE, exec, playerctl play-pause"

        # General keybindings
        "$mainMod, Q, killactive"
        "$mainMod, G, togglefloating"
        "$mainMod, M, fullscreen"
        "$mainMod, S, pseudo"
        "$mainMod, V, togglesplit,"

        # Change window focus
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Move windows in workspace
        "$shiftmod, H, movewindow, l"
        "$shiftmod, L, movewindow, r"
        "$shiftmod, K, movewindow, u"
        "$shiftmod, J, movewindow, d"
        "$shiftmod, left, movewindow, l"
        "$shiftmod, right, movewindow, r"
        "$shiftmod, up, movewindow, u"
        "$shiftmod, down, movewindow, d"

        # Change workspaces
        "$ctrlmod, K, workspace, e+1"
        "$ctrlmod, J, workspace, e-1"

        # Window resizing
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"

        # Notification Center
        "$mainMod, N, exec, swaync-client -t"

        # Restart Waybar
        "$shiftmod, W, exec, /home/itm154/.config/hypr/waybar.sh"

        # Global shortcut
        "ALT, Alt_R, pass,^discord$"
      ];

      # Mousebindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # General config
      general = {
        gaps_in = 4;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "0xff1e1e2e";
        "col.inactive_border" = "0xff1e1e2e";
        layout = "dwindle";
      };

      # Keyboard config
      input = {
        kb_layout = "us";
        repeat_rate = 50;
        repeat_delay = 180;
        follow_mouse = 1;
        sensitivity = 0;
        accel_profile = "flat";
        touchpad = {
          disable_while_typing = 1;
          tap-to-click = 1;
          natural_scroll = true;
        };
      };

      # Eyecandy
      decoration = {
        rounding = 8;
        inactive_opacity = 0.8;
        drop_shadow = true;
        shadow_range = 8;
        shadow_render_power = 2;
        "col.shadow" = "rgba(1a1a1aee)";
        blur = {
          enabled = true;
          new_optimizations = true;
          size = 4;
          passes = 2;
        };
      };

      # More eyecandy
      animations = {
        enabled = true;
        bezier = "betterease, 0.05, 0.9, 0.1, 1";
        animation = [
          "windows, 1, 5, betterease"
          "windowsIn, 1, 5, betterease, slide"
          "windowsOut, 1, 5, default, popin 80%"
          "border, 1, 5, default"
          "fade, 1, 7, default"
          "workspaces, 1, 3, betterease"
          "specialWorkspace, 1, 3, betterease, slidevert"
        ];
      };

      # Window Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        # force_split = 2
      };
      master = { new_is_master = true; };

      # Rules
      windowrule =
        [ "float, Rofi" "tile, kitty" "tile, wezterm" "tile, spotify" ];

      # Miscellanious
      misc = {
        disable_hyprland_logo = 1;
        disable_splash_rendering = 1;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        vfr = true;
      };

      # Hyprland environment variables
      env = [ "QT_QPA_PLATFORM,wayland" "SDL_VIDEODRIVER,wayland" ] ++ (
        # Workspaces
        # binds $mainMod + [shift +] {1..6} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (x:
          let ws = let c = (x + 1) / 6; in builtins.toString (x + 1 - (c * 6));
          in [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]) 6));
    };
  };
}
