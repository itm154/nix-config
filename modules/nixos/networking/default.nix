{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.software.networking;
in {
  options.software.networking = {
    enable = mkEnableOption "Basic network configuration";
    hostName = mkOption {
      type = types.str;
      default = "nix";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = "${cfg.hostName}";
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      firewall = {
        enable = true;
        # 53317 for Localsend
        allowedTCPPorts = [80 443 53317];
        allowedUDPPortRanges = [
          {
            from = 4000;
            to = 4007;
          }
          {
            from = 53315;
            to = 53318;
          }
          {
            from = 8000;
            to = 8010;
          }
        ];
      };
    };
  };
}
