{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.locales;
in {
  options.system.locales = with types; {
    enable = mkBoolOpt false "Enable locales";
    cjkSupport = mkBoolOpt true "Enable CJK region language and locales";
  };

  config = mkIf cfg.enable {
    # Locales and input
    time.timeZone = "Asia/Kuching";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        (mkIf cfg.cjkSupport "ja_JP.UTF-8/UTF-8")
      ];
      extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };
    };
  };
}
