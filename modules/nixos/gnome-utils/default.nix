{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.gnome-utils;
in {
  options.services.gnome-utils = {
    enable = mkEnableOption "Enables gnome-polkit and gnome keyrings";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    systemd = {
      user = {
        services.polkit-gnome-authentication-agent-1 = {
          description = "polkit-gnome-authentication-agent-1";
          wantedBy = ["graphical-session.target"];
          wants = ["graphical-session.target"];
          after = ["graphical-session.target"];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
        extraConfig = ''
          DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
        '';
      };
    };
  };
}
