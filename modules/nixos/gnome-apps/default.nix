{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.gnome-apps;
in {
  options.programs.gnome-apps = {
    enable = mkEnableOption "Installs basic gnome apps";
  };

  config = mkIf cfg.enable {
    # Enables trash bin in nautilus
    services.gvfs.enable = true;

    environment.systemPackages = with pkgs; [
      gnome.file-roller
      gnome.gnome-calculator
      gnome.gnome-disk-utility
      gnome.gnome-font-viewer
      gnome.nautilus
      gnome.totem
    ];
  };
}
