{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.libinput;
in {
  options.system.libinput = with types; {
    enable = mkBoolOpt true "Enable libinput";
  };

  config = mkIf cfg.enable {
    services.libinput.enable = true;
  };
}
