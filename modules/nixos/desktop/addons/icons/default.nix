{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.icons;
in {
  options.desktop.addons.icons = with types; {
    enable = mkBoolOpt true "Enable papirus icons";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Apparently catppuccin-papirus-folders already includes all of the icons and adding this just stretches the rebuild time
      # papirus-icon-theme
      (catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "maroon";
      })
    ];
  };
}
