# WARNING: This module will be deprecated because gtk theming sucks, use qt/kde instead
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.gtk;
in {
  options.desktop.addons.gtk = with types; {
    enable = mkBoolOpt false "Enable gtk theming";
  };

  config = mkIf cfg.enable {
    home.extraOptions = {
      gtk = {
        enable = true;
        catppuccin = {
          enable = true;
          icon.enable = true;
          icon.accent = "maroon";
        };
        font = {
          package = pkgs.cantarell-fonts;
          name = "Cantarell";
          size = 12;
        };
      };
    };
  };
}
