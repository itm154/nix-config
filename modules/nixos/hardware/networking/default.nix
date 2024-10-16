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
      tcp = {
        allowedPorts = mkOpt (listOf port) [] "Allowed TCP ports";
        allowedPortRanges = mkOpt (listOf (attrsOf port)) [] "Allowed TCP port ranges";
      };
      udp = {
        allowedPorts = mkOpt (listOf port) [] "Allowed UDP ports";
        allowedPortRanges = mkOpt (listOf (attrsOf port)) [] "Allowed UDP port ranges";
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
        # NOTE: IWD supposedly works better with intel wifi cards (we'll see)
        wifi.backend = "iwd";
      };

      firewall = {
        enable = true;
        allowedTCPPorts = cfg.firewall.tcp.allowedPorts;
        allowedTCPPortRanges = cfg.firewall.tcp.allowedPortRanges;
        allowedUDPPorts = cfg.firewall.udp.allowedPorts;
        allowedUDPPortRanges = cfg.firewall.udp.allowedPortRanges;
      };
    };
  };
}
