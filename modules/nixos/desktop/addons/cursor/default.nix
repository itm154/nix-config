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
    enable = mkBoolOpt false "Enable cursor theming";
  };

  config = mkIf cfg.enable {
    home.extraOptions = {
      catppuccin = {
        pointerCursor = {
          enable = true;
          accent = "red";
        };
      };
    };
  };
}
