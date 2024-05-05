{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.software.core;
in {
  options.software.core = {
    enable = mkEnableOption "Essential system configurations";
  };

  config = mkIf cfg.enable {
    # Bootloader
    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };

    # Display manager
    services.xserver = {
      enable = true;
      libinput.enable = true;
      xkb = {
        variant = "";
        layout = "us";
      };
    };

    # Prevent shutdown with short press
    services.logind.extraConfig = ''HandlePowerKey=ignore'';
    services.dbus.enable = true;

    # Locales and input
    time.timeZone = "Asia/Kuching";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = ["en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8"];
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

    # Audio
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
