{
  stdenv,
  lib,
  fetchFromGitHub,
  pkgs,
  kernel ? pkgs.linuxPackages_zen.kernel,
  kmod,
}:
stdenv.mkDerivation rec {
  name = " acer-predator-turbo-and-rgb-keyboard-linux-module-${version}-${kernel.modDirVersion}";
  version = "main";

  src = fetchFromGitHub {
    owner = "JafarAkhondali";
    repo = "acer-predator-turbo-and-rgb-keyboard-linux-module";
    rev = "${version}";
    sha256 = "NIy5fGNsY4MeKm6Sh2iOhRFj8nI+R8OoAwbBx4uujqw=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';
  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags =
    kernel.makeFlags
    ++ [
      "-C"
      "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "M=$(sourceRoot)"
    ];
  buildFlags = ["modules"];
  installFlags = ["INSTALL_MOD_PATH=${placeholder "out"}"];
  installTargets = ["modules_install"];

  meta = with lib; {
    description = "Improved Linux driver for Acer RGB Keyboards ";
    homepage = "https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module";
    license = licenses.gpl3;
    maintainers = [];
    platforms = platforms.linux;
  };
}
