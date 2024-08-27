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
    enable = mkBoolOpt false "Enable sddm";
  };

  config = mkIf cfg.enable {
    # TODO: Make this optional/a module
    # security.pam.services = {
    #   sddm.enableGnomeKeyring = true;
    # };
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
