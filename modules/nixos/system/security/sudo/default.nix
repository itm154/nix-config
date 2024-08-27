{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.security.sudo;
in {
  options.system.security.sudo = with types; {
    enable = mkBoolOpt true "Enable sudo command";
  };

  config = mkIf cfg.enable {
    security.sudo = {
      enable = true;
    };
  };
}
