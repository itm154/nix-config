{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.software.core-fonts;
in {
  options.software.core-fonts = {
    enable = mkEnableOption "Basic system fonts";
  };

  config = mkIf cfg.enable {
    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
      source-sans
      source-serif
      source-han-sans
      source-han-mono
      source-han-serif
      corefonts
    ];
  };
}
