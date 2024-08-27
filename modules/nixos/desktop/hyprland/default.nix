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
in {
  options.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Enable hyprland";
    display = mkOpt str "eDP-1, 1920x1200@165, 0x0, 1" "Display configuration";
  };

  config = mkIf cfg.enable {
    home.extraOptions.wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";
        "$shiftMod" = "SUPERSHIFT";
        "$ctrlMod" = "SUPERCTRL";

        monitor = "eDP-1, 1920x1080@60, 0x0, 1";

        exec-once = [
          "fcitx5"
        ];

        # Environment variables for hyprland
        env = [
        ];

        # Keybindings
        bind =
          [
            # Applications
            "$mainMod, Return, exec, kitty"
            "$mainMod, B, exec, firefox"

            # Device controls
            ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"
            ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
            "$mainMod, XF86AudioRaiseVolume, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"
            "$mainMod, XF86AudioLowerVolume, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"

            ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

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
        blurls = [];

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
        windowrule = [
          "tile, kitty"
        ];
        windowrulev2 = [
        ];

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
    environment.systemPackages = with pkgs; [
      wl-clipboard
      xwaylandvideobridge
      wlr-randr
    ];
    environment.sessionVariables = {
      # NOTE: Things may not work if these are enabled
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
  };
}
