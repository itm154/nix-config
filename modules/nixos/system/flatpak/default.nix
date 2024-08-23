{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.flatpak;
in {
  options.system.flatpak = with types; {
    enable = mkBoolOpt false "Enable flatpak";
    fixIcons = mkBoolOpt false "Fix issues with fonts and icon not appearing in flatpak apps";
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;

    # Only include these options if fixIcons is set to true
    system.fsPackages = mkIf cfg.fixIcons [pkgs.bindfs];
    fileSystems = mkIf cfg.fixIcons (let
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
    });
  };
}
