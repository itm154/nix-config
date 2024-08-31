{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.fish;
in {
  options.cli.fish = with types; {
    enable = mkBoolOpt false "Enable fish as default user shell";
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;
    users.users.${config.user.name} = {
      shell = pkgs.fish;
    };
  };
}
