{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.qt;
in {
  options.desktop.addons.qt = with types; {
    enable = mkBoolOpt true "Enable qt theming";
  };

  config = mkIf cfg.enable {
    home.extraOptions = {
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style = {
          name = "kvantum";
          catppuccin.enable = true;
        };
      };
    };
  };
}
