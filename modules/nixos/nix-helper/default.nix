{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.software.nix-helper;
in {
  options.software.nix-helper = {
    enable = mkEnableOption "Commandline helper program for nixos";
    flake-dir = mkOption {
      type = types.str;
      default = "/home/itm154/Repository/nix-config";
    };
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      FLAKE = "${cfg.flake-dir}";
    };

    environment.systemPackages = [pkgs.nh];
  };
}
