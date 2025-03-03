{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.clipboard;
in {
  options.desktop.addons.clipboard = {
    enable = mkBoolOpt false "Clipboard";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [wl-clipboard];};
}
