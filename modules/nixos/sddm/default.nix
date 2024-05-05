{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.software.sddm;
in {
  options.software.sddm = {
    enable = mkEnableOption "Enables sddm display manager";
  };

  config = mkIf cfg.enable {
    security.pam.services = {
      sddm.enableGnomeKeyring = true;
    };
    services.displayManager.sddm = {
      enable = true;
      theme = "rose-pine";
    };

    environment.systemPackages = with pkgs; [
      sddm-rose-pine
    ];
  };
}
