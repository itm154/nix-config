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
    enable = mkBoolOpt true "Enable xkb";
    layout = mkOpt str "us" "Keyboard layout";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      xkb = {
        variant = "";
        layout = cfg.layout;
      };
    };
  };
}
