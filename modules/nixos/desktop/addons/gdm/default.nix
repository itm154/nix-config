{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.gdm;
in {
  options.desktop.addons.gdm = with types; {
    enable = mkBoolOpt false "Enable gdm";
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
