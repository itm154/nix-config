{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.ime;
in {
  options.services.ime = with types; {
    enable = mkBoolOpt false "Enable IME";
    extraModules = mkOpt (listOf package) [pkgs.fcitx5-mozc] "Extra fcitx5 modules";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [fcitx5-gtk fcitx5-qt] ++ cfg.extraModules;
    };
    services.xserver.desktopManager.runXdgAutostartIfNone = true;

    home.extraOptions = {
      i18n.inputMethod.fcitx5.catppuccin.enable = true;
    };

    environment.sessionVariables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "ibus";
      XMODIFIERS = "@im=fcitx";
    };
  };
}
