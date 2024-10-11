{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.sway;
  term = pkgs.kitty;
  substitutedConfig = pkgs.substituteAll {
    src = ./config;
    term = "kitty";
  };
in {
  options.desktop.sway = with types; {
    enable = mkBoolOpt false "Enable sway";
    wallpaper = mkOpt (nullOr package) null "Wallpaper";
    extraConfig = mkOpt str "" "Additional configuration";
  };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      extraPackages = with pkgs; [
        playerctl
        brightnessctl
        swaylock
      ];

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
      '';
    };

    home.configFile."sway/config".text = fileWithText substitutedConfig ''
      #############################
      #░░░░░░░░░░░░░░░░░░░░░░░░░░░#
      #░░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█░░#
      #░░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█░░#
      #░░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀░░#
      #░░░░░░░░░░░░░░░░░░░░░░░░░░░#
      #############################

      # Launch services waiting for the systemd target sway-session.target
      exec "systemctl --user import-environment; systemctl --user start sway-session.target"

      # Start a user session dbus (required for things like starting
      # applications through wofi).
      exec dbus-daemon --session --address=unix:path=$XDG_RUNTIME_DIR/bus

      ${optionalString (cfg.wallpaper != null) ''
        output * {
          bg ${cfg.wallpaper.gnomeFilePath or cfg.wallpaper} fill
        }
      ''}

        ${cfg.extraConfig}
    '';
    systemd.user.targets.sway-session = {
      description = "Sway compositor session";
      documentation = ["man:systemd.special(7)"];
      bindsTo = ["graphical-session.target"];
      wants = ["graphical-session-pre.target"];
      after = ["graphical-session-pre.target"];
    };

    systemd.user.services.sway = {
      description = "Sway - Wayland window manager";
      documentation = ["man:sway(5)"];
      bindsTo = ["graphical-session.target"];
      wants = ["graphical-session-pre.target"];
      after = ["graphical-session-pre.target"];
      # We explicitly unset PATH here, as we want it to be set by
      # systemctl --user import-environment in startsway
      environment.PATH = lib.mkForce null;
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
        '';
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    desktop.addons = {
      clipboard.enable = true;
      cursor.enable = true;
      xdgPortal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-wlr];
      };
    };

    services.xserver.enable = true;
  };
}
