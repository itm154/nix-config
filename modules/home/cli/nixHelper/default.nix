{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.nixHelper;
in {
  options.cli.nixHelper = with types; {
    enable = mkBoolOpt false "Enable nix-helper";
    flakeDir = mkOpt types.str null "Flake-directory";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      FLAKE = "${cfg.flakeDir}";
    };

    home.packages = with pkgs; [nh];
  };
}
