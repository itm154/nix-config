{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.nh;
in {
  options.cli.nh = with types; {
    enable = mkBoolOpt false "Enable nix-helper";
    flakeDir = mkOpt str "/home/itm154/Repository/nix-config" "Flake-directory";
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep 5";
      flake = cfg.flakeDir;
    };
  };
}
