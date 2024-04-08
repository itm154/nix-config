{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.software.wayland-core;
in {
  options.software.wayland-core = {
    enable = mkEnableOption "Configuration for wayland desktops";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {WLR_NO_HARDWARE_CURSORS = "1";};

    # Enable gtk portal for consistency
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
