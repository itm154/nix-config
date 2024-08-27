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
    enable = mkBoolOpt true "Enable locales";
    timeZone = mkOpt str "Asia/Kuching" "Timezone";
    cjkSupport = mkBoolOpt true "Enable CJK region language and locales";
    extraLocales = mkOpt (listOf str) [] "Extra locales";
  };

  config = mkIf cfg.enable {
    time.timeZone = cfg.timeZone;
    i18n = {
      # NOTE: Just using US locales because it just works
      defaultLocale = "en_US.UTF-8";
      supportedLocales =
        [
          "en_US.UTF-8/UTF-8"
          (mkIf cfg.cjkSupport "ja_JP.UTF-8/UTF-8")
        ]
        ++ cfg.extraLocales;
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
