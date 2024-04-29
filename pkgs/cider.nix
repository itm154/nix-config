{
  appimageTools,
  lib,
  ...
}:
appimageTools.wrapType2 rec {
  pname = "cider";
  version = "2.3.1";
  name = "${pname}-${version}";

  src = ../bins/Cider-${version}.AppImage;

  extraInstallCommands = let
    contents = appimageTools.extract {inherit name src;};
  in ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${contents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A new look into listening and enjoying Apple Music in style and performance.";
    homepage = "https://github.com/ciderapp/Cider";
    license = licenses.gpl3;
    platforms = [
      "x86_64-linux"
      /*
      ...
      */
    ];
  };
}
