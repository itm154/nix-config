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
    flakeDir = mkOpt types.str "/home/${config.snowfallorg.user.name}/Repository/nix-config" "Flake-directory";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      FLAKE = "${cfg.flakeDir}";
    };

    environment.systemPackages = [pkgs.nh];
  };
}
