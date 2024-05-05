{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.software.gdm;
in {
  options.software.gdm = {
    enable = mkEnableOption "Enables gdm display manager";
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
      settings = {
        greeter.IncludeAll = true;
      };
    };
  };
}
