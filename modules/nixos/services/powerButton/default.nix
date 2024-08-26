{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.powerButton;
in {
  options.services.powerButton = with types; {
    enable = mkBoolOpt true "Prevent powerbutton from shutting down machine with short press";
  };

  config = mkIf cfg.enable {
    services.logind.extraConfig = ''HandlePowerKey=ignore'';
  };
}
