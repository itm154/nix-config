{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.xdgPortal;
in {
  options.desktop.addons.xdgPortal = with types; {
    enable = mkBoolOpt false "Enable xdg-desktop-portal";
    extraPortals = mkOpt (listOf package) [] "Extra portals";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["kde"];
        hyprland = {
          default = ["hyprland" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["kde"];
        };
      };
      extraPortals = with pkgs;
        [
          xdg-desktop-portal-kde
        ]
        ++ cfg.extraPortals;
    };
  };
}
