{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.swaync;
in {
  options.desktop.addons.swaync = with types; {
    enable = mkBoolOpt false "Enable swaync";
  };

  config = mkIf cfg.enable {
    home.file.".config/swaync" = {
      source = ./config;
      recursive = true;
    };
  };
}
