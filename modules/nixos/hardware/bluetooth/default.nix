{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.bluetoothctl;
in {
  options.hardware.bluetoothctl = with types; {
    enable = mkBoolOpt false "Enable bluetooth";
  };

  config = mkIf cfg.enable {
    hardware = {
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}
