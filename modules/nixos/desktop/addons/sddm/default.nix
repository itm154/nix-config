{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.sddm;
in {
  options.desktop.addons.sddm = with types; {
    enable = mkBoolOpt true "Enable sddm";
  };

  config = mkIf cfg.enable {
    security.pam.services = {
      sddm.kwallet.enable = true;
    };

    services.displayManager.sddm = {
      package = pkgs.lib.mkForce pkgs.libsForQt5.sddm;
      extraPackages = pkgs.lib.mkForce [pkgs.libsForQt5.qt5.qtgraphicaleffects];
      enable = true;
      wayland.enable = true;
      theme = "rose-pine";
    };

    environment.systemPackages = with pkgs.custom; [
      sddm-rose-pine
    ];
  };
}
