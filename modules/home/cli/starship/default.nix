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
      enableFishIntegration = cfg.fishIntegration;
      enableBashIntegration = cfg.bashIntegration;
      settings =
        {
          format = "$all";
          palette = "catppuccin_mocha";
        }
        // builtins.fromTOML (builtins.readFile (pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "starship";
            rev = "5629d23";
            sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
          }
          + /palettes/mocha.toml));
    };
  };
}
