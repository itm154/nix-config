{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.gh;
in {
  options.cli.gh = with types; {
    enable = mkBoolOpt false "Enable github cli";
  };

  config = mkIf cfg.enable {
    programs.gh.enable = true;
  };
}
