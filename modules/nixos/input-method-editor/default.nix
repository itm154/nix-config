{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.software.input-method-editor;
in {
  options.software.input-method-editor = {
    enable = mkEnableOption "Enable IME for multilingual input (Currently only Japanese)";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk];
    };
    services.xserver.desktopManager.runXdgAutostartIfNone = true;
  };
}
