{ config, pkgs, ...}: {
  stdenv.mkDerivation = {
    name = "Icomoon-Feather";
    dontConfigure = true;
    src = pkgs.fetchurl {
      url = "https://github.com/adi1090x/rofi/raw/master/fonts/Icomoon-Feather.ttf";
      hash = "sha256-0n01h49l49n8n1m8g1f6dhyn6cc1d82jxmpjzs5ydsrbmxi83b4h";
      stripRoot = false;
    };

    installPhase = ''
      cp -R $src $out/share/fonts/truetype/
    '';
  };
}
