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
      papirus-icon-theme
      (catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "maroon";
      })
    ];
  };
}
