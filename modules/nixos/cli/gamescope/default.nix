{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.gamescope;
in {
  options.cli.gamescope = with types; {
    enable = mkBoolOpt false "Enable gamescope";
  };

  config = mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
