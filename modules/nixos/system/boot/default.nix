{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.boot;
in {
  options.system.boot = with types; {
    enable = mkBoolOpt false "Enable boot";
    entries = mkOpt int 5 "Amount of entries available";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = cfg.entries;

        # NOTE: https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
