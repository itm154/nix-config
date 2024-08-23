{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.fonts;
in {
  options.system.fonts = with types; {
    enable = mkBoolOpt false "Enable core system fonts";
    extraFonts = mkOpt (listOf package) [] "Extra fonts to install";
  };

  config = mkIf cfg.enable {
    fonts.fontDir.enable = true;
    fonts.packages = with pkgs;
      [
        corefonts
        source-sans
        source-serif
        source-han-sans
        source-han-mono
        source-han-serif
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
      ]
      ++ cfg.extraFonts;
  };
}
