{
  config,
  pkgs,
  ...
}: let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &
    ${pkgs.swaynotificationcenter}/bin/swaync &

    sleep 1

    ${pkgs.swww}/bin/swww img ~/Pictures/Wallpapers/3.jpg &
    ${pkgs.arrpc}/bin/arrpc &
  '';
  restartWaybar = pkgs.pkgs.writeShellScriptBin "restartWaybar" ''
    pkill waybar
    ${pkgs.waybar}/bin/waybar & disown
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$shiftMod" = "SUPERSHIFT";
      "$ctrlMod" = "SUPERCTRL";

      monitor = "eDP-1, 1920x1080@60, 0x0, 1";

      exec-once = [
        "${startupScript}/bin/start"

        # Temporary fix for fcitx5
        "fcitx5"
      ];

      # Environment variables for hyprland
      env = [
        "QT_QPA_PLATFORM,wayland"
        # "QT_STYLE_OVERRIDE,kvantum"
        "SDL_VIDEODRIVER,wayland"
        "SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS,0"
        "MOZ_ENABLE_WAYLAND,1"
        "GDK_BACKEND,wayland"
        "GTK_USE_PORTAL,1"
        "GTK_IM_MODULE,fcitx"
        "QT_IM_MODULE,fcitx"
        "SDL_IM_MODULE,fcitx"
      ];

      # Keybindings
      bind =
        [
          # Applications
          "$mainMod, Return, exec, kitty"
          "$mainMod, B, exec, firefox"

          # Scripts
          "$shiftMod, S, exec, grimblast --notify copysave area $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')"
          "$shiftMod , A, exec, grimblast --notify copysave screen $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')"
          "$mainMod, D, exec, rofi-launcher"
          "$mainMod, X, exec, $HOME/.config/rofi/powermenu/powermenu.sh"

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
          "$shiftMod, H, movewindow, l"
          "$shiftMod, L, movewindow, r"
          "$shiftMod, K, movewindow, u"
          "$shiftMod, J, movewindow, d"
          "$shiftMod, left, movewindow, l"
          "$shiftMod, right, movewindow, r"
          "$shiftMod, up, movewindow, u"
          "$shiftMod, down, movewindow, d"

          # Change workspaces
          "$ctrlMod, K, workspace, e+1"
          "$ctrlMod, J, workspace, e-1"

          # Notification Center
          "$mainMod, N, exec, swaync-client -t"

          # Restart waybar
          "$shiftMod, W, exec, ${restartWaybar}/bin/restartWaybar"

          # Global shortcut
          "ALT, Alt_R, pass,^discord$"
        ]
        ++ (
          # Workspaces
          # binds $mainMod + [shift +] {1..6} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (x: let
              ws = let c = (x + 1) / 6; in builtins.toString (x + 1 - (c * 6));
            in [
              "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ])
            6)
        );

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

      gestures = {
        workspace_swipe = true;
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
      blurls = ["waybar"];

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
      master = {new_is_master = true;};

      # Rules
      windowrule = ["float, Rofi" "tile, kitty" "tile, wezterm" "tile, spotify" "stayfocused, class:(steam), title:(^$)"];
      windowrulev2 = ["stayfocused, class:(steam), title:(^$)"];

      # Miscellanious
      misc = {
        disable_hyprland_logo = 1;
        disable_splash_rendering = 1;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        vfr = true;
      };
    };
  };
}
