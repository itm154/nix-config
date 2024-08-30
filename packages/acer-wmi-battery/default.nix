{
  stdenv,
  lib,
  fetchFromGitHub,
  pkgs,
  kernel ? pkgs.linuxPackages_zen.kernel,
  kmod,
}:
stdenv.mkDerivation rec {
  name = "acer-wmi-battery-${version}-${kernel.version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "frederik-h";
    repo = "acer-wmi-battery";
    rev = "v${version}";
    sha256 = "0b8h4qgqdgmzmzb2hvsh4psn3d432klxdfkjsarpa89iylr4irfs";
  };

  setSourceRoot = ''export sourceRoot=$(pwd)/source'';
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
    description = "A linux kernel driver for the Acer WMI battery health control interface";
    homepage = "https://github.com/frederik-h/acer-wmi-battery";
    license = licenses.gpl2;
    maintainers = [maintainers.itm154];
    platforms = platforms.linux;
  };
}
