{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.hyprland;

  volumectl = pkgs.writeShellScriptBin "volumectl" ''
    case "$1" in
      up)
        ${pkgs.wireplumber}/bin/wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ "$2"%+
        ;;
      down)
        ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ "$2"%-
        ;;
      mute)
        ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    esac
  '';

  restartWaybar = pkgs.pkgs.writeShellScriptBin "restartWaybar" ''
    pkill waybar
    ${pkgs.waybar}/bin/waybar & disown
  '';

  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww-daemon &
    ${pkgs.swaynotificationcenter}/bin/swaync &

    sleep 1

    ${pkgs.swww}/bin/swww img ${cfg.wallpaper} &
    ${pkgs.arrpc}/bin/arrpc &
    ${pkgs.kdePackages.kwallet}/bin/kwalletd6 &
  '';
in {
  options.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Enable hyprland";
    wallpaper = mkOption {
      type = types.oneOf [
        types.package
        types.path
        types.str
      ];
      default = ./background.jpg;
      description = "The wallpaper to use.";
    };
    settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra Hyprland settings to apply.";
    };
  };

  config = mkIf cfg.enable {
    desktop.addons = {
      cursor.enable = true;
      rofi.enable = true;
      waybar.enable = true;
      swaync.enable = true;
      icons.enable = true;
      xdgPortal = {
        enable = true;
        extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-hyprland];
      };
    };

    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
    environment.systemPackages = with pkgs; [
      volumectl
      playerctl
      brightnessctl
      swaynotificationcenter
      glib # For gsettings
    ];

    programs.hyprland.enable = true;
    home.extraOptions.wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";
        "$shiftMod" = "SUPERSHIFT";
        "$ctrlMod" = "SUPERCTRL";

        monitor = "eDP-1, 1920x1200@165, 0x0, 1";

        exec-once = [
          "${startupScript}/bin/start"

          # Temporary fix for fcitx5
          "fcitx5"
        ];

        # Environment variables for hyprland
        env = [
          "QT_QPA_PLATFORM,wayland"
          # "QT_STYLE_OVERRIDE,kvantum"
          "QT_QPA_PLATFORMTHEME,kde"
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
            "$shiftMod, S, exec, ${pkgs.grimblast}/bin/grimblast --notify copysave area $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')"
            "$shiftMod , A, exec, ${pkgs.grimblast}/bin/grimblast --notify copysave screen $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')"
            "$mainMod, D, exec, rofi-launcher"
            "$mainMod, X, exec, $HOME/.config/rofi/powermenu/powermenu.sh"

            # Device controls
            ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"
            ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
            "$mainMod, XF86AudioRaiseVolume, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"
            "$mainMod, XF86AudioLowerVolume, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"

            # ", XF86AudioRaiseVolume, exec, pamixer -i 5"
            # ", XF86AudioLowerVolume, exec, pamixer -d 5"
            # ", XF86AudioMute, exec, pactl set-sink-mute 0 toggle"

            ", XF86AudioRaiseVolume, exec, volumectl up 5"
            ", XF86AudioLowerVolume, exec, volumectl down 5"
            ", XF86AudioMute, exec, volumectl mute"

            ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
            "$mainMod, SPACE, exec, ${pkgs.playerctl}/bin/playerctl play-pause"

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
          border_size = 0;
          layout = "dwindle";
          allow_tearing = true;
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
          inactive_opacity = 0.80;
          drop_shadow = true;
          shadow_range = 50;
          shadow_render_power = 4;
          shadow_ignore_window = true;
          "col.shadow" = "0x99161925";
          "col.shadow_inactive" = "0x55161925";
          blur = {
            enabled = true;
            new_optimizations = true;
            size = 5;
            passes = 4;
            xray = true;
            ignore_opacity = true;
          };
        };

        blurls = ["waybar"];

        # More eyecandy
        animations = {
          enabled = true;
          bezier = [
            "overshot, 0.13, 0.99, 0.29, 1.1"
            "shot, 0.2, 1.0, 0.2, 1.0"
            "swipe, 0.6, 0.0, 0.2, 1.05"
            "linear, 0.0, 0.0, 1.0, 1.0"
            "progressive, 1.0, 0.0, 0.6, 1.0"
          ];
          animation = [
            "windows, 1, 6, shot, slide"
            "workspaces, 1, 6, shot, slide"
            "fade, 1, 4, linear"
          ];
        };

        # Window Layout
        dwindle = {
          pseudotile = true;
          preserve_split = true;
          # force_split = 2
        };

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
  };
}
