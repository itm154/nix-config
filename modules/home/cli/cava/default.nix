{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.cava;
in {
  options.cli.cava = with types; {
    enable = mkBoolOpt false "Enable cava";
  };

  config = mkIf cfg.enable {
    programs.cava.enable = true;

    xdg.configFile."cava/config".source = ./config/config;

    xdg.configFile."cava/barConfig".source = ./config/barConfig;
  };
}
