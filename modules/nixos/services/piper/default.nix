{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.piper;
in {
  options.services.piper = with types; {
    enable = mkBoolOpt false "Enable module";
  };

  config = mkIf cfg.enable {
    services.ratbagd.enable = true;

    environment.systemPackages = with pkgs; [
      piper
    ];
  };
}
