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
    barIntegration = mkBoolOpt false "Enable configuration for use in bars";
  };

  config = mkIf cfg.enable {
    programs.cava.enable = true;

    xdg.configFile."cava/config".source = ./config/config;
    xdg.configFile."cava/mocha.cava" .source = ./config/mocha.cava;

    xdg.configFile."cava/barIntegrationConfig".source =
      if cfg.barIntegration
      then ./config/barIntegrationConfig
      else null;
  };
}
