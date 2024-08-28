{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.secureBoot;
in {
  options.system.secureBoot = with types; {
    enable = mkBoolOpt false "Enable secure boot";
    entries = mkOpt int 5 "Amount of entries available";
  };

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sbctl
    ];

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      configurationLimit = cfg.entries;
    };
  };
}
