{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.plasma;
in {
  options.desktop.plasma = with types; {
    enable = mkBoolOpt false "Enable KDE Plasma 6";
    x11 = mkBoolOpt true "Enable X11 session for Plasma";
    # INFO: See https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/plasma6.nix#L136-L149
    excludePackages =
      mkOpt (listOf package) [] "Excluded Plasma packages";
  };

  config = mkIf cfg.enable {
    services.xserver = mkIf cfg.x11 {enable = true;};
    desktop.addons = {
      xdgPortal.enable = true;
    };
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages;
      []
      ++ cfg.excludePackages;
  };
}
