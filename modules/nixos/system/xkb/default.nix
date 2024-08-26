{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.xkb;
in {
  options.system.xkb = with types; {
    enable = mkBoolOpt false "Enable system.xkb";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      xkb = {
        variant = "";
        layout = "us";
      };
    };
  };
}
