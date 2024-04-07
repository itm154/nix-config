{
  options,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware.tablets;
in {
  options.hardware.tablets = {
    enable = mkEnableOption "Enable support for drawing tablets";
  };

  config = mkIf cfg.enable {
    hardware.opentabletdriver.enable = true;
    hardware.opentabletdriver.daemon.enable = true;
  };
}
