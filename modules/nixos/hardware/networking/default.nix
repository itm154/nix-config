{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.networking;
in {
  options.hardware.networking = with types; {
    enable = mkBoolOpt false "Enable networking";
    firewall = {
      allowedTCPPorts = mkOpt {
        type = listOf int;
        default = [];
        description = "List of allowed TCP ports";
      };
      allowedUDPPortRanges = mkOpt {
        type = listOf (attrsOf int);
        default = [];
        description = "List of allowed UDP ports";
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };

      firewall = {
        enable = true;
        allowedTCPPorts = cfg.firewall.allowedTCPPorts;
        allowedUDPPortRanges = cfg.firewall.allowedUDPPortRanges;
      };
    };
  };
}
