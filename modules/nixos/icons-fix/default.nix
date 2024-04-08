{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.software.icons-fix;
in {
  options.software.icons-fix = {
    enable = mkEnableOption "Fixes issues with fonts not appearing in flatpak applications";
  };

  config = mkIf cfg.enable {
    # Fixes issues with fonts not appearing
    system.fsPackages = [pkgs.bindfs];
    fileSystems = let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = ["/share/fonts"];
      };
      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths = with pkgs; [
          gnome.gnome-themes-extra
          bibata-cursors
        ];
        pathsToLink = ["/share/icons"];
      };
    in {
      # Create an FHS mount to support flatpak host icons/fonts
      "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      "/usr/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    };
  };
}
