{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.drawingTablet;
in {
  options.hardware.drawingTablet = with types; {
    enable = mkBoolOpt false "Enable support for drawing tablets";
  };

  config = mkIf cfg.enable {
    hardware.opentabletdriver.enable = true;
    hardware.opentabletdriver.daemon.enable = true;
  };
}
