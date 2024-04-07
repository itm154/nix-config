{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.noisetorch;
in {
  options.services.noisetorch = {
    enable = mkEnableOption "Enables noisetorch as a systemd service";
  };

  config = mkIf cfg.enable {
    security.wrappers.noisetorch = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_resource=+ep";
      source = "${pkgs.noisetorch}/bin/noisetorch";
    };

    environment.systemPackages = [pkgs.noisetorch];

    systemd = {
      user = {
        services.noisetorch = {
          description = "Noisetorch noise supression";
          requires = ["sys-devices-pci0000:00-0000:00:1f.3-sound-card0-controlC0.device"];
          after = ["pipewire.service" "sys-devices-pci0000:00-0000:00:1f.3-sound-card0-controlC0.device"];
          wantedBy = ["default.target"];
          serviceConfig = {
            Type = "forking";
            ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i -s alsa_input.pci-0000_00_1f.3.analog-stereo -t 80";
            # ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
            Restart = "on-failure";
            RestartSec = 3;
          };
        };
      };
    };
  };
}
