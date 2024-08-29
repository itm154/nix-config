{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.cursor;
in {
  options.desktop.addons.cursor = with types; {
    enable = mkBoolOpt true "Enable cursor theming";
  };

  config = mkIf cfg.enable {
    home.extraOptions = {
      pointerCursor = {
        enable = true;
        accent = "red";
      };
    };
  };
}
