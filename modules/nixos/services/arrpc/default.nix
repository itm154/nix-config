{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.arrpc;
in {
  options.services.arrpc = with types; {
    enable = mkBoolOpt false "Enable arrpc service";
    systemdTarget = mkOption {
      type = types.str;
      default = "graphical-session.target";
      example = "sway-session.target";
      description = ''
        Systemd target to bind to.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.arRPC = {
      description = "Discord Rich Presence for browsers, and some custom clients";
      partOf = ["graphical-session.target"];

      wantedBy = [cfg.systemdTarget];
      serviceConfig = {
        ExecStart = lib.getExe pkgs.arrpc;
        Restart = "always";
      };
    };
  };
}
