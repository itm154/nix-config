{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.starship;
in {
  options.cli.starship = with types; {
    enable = mkBoolOpt false "Enable module";
    fishIntegration = mkBoolOpt false "Enable fish integration";
    bashIntegration = mkBoolOpt false "Enable bash integration";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      catppuccin.enable = true;
      enableFishIntegration = cfg.fishIntegration;
      enableBashIntegration = cfg.bashIntegration;
    };
  };
}
