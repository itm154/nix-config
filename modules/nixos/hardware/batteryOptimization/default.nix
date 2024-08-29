{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.batteryOptimization;
in {
  options.hardware.batteryOptimization = with types; {
    enable = mkBoolOpt false "Enable battery optimization for laptops";
  };

  config = mkIf cfg.enable {
    services.power-profiles-daemon.enable = false; # Disable power-profiles-daemon (conflicts with TLP)
    services.thermald.enable = true;
    services.tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        USB_AUTOSUSPEND = 1;
        RUNTIME_PM_ON_AC = "auto";
      };
    };

    services.system76-scheduler = {
      enable = true;
      useStockConfig = false; # our needs are modest
      settings = {
        cfsProfiles.default.preempt = "full";
        processScheduler = {
          pipewireBoost.enable = false;
          foregroundBoost.enable = false;
        };
      };
      assignments = {
        batch = {
          class = "batch";
          matchers = [
            "bazel"
            "clangd"
            "rust-analyzer"
          ];
        };
      };
      # do not disturb adults:
      exceptions = [
        "include descends=\"schedtool\""
        "include descends=\"nice\""
        "include descends=\"chrt\""
        "include descends=\"taskset\""
        "include descends=\"ionice\""

        "schedtool"
        "nice"
        "chrt"
        "ionice"

        "dbus"
        "dbus-broker"
        "rtkit-daemon"
        "taskset"
        "systemd"
      ];
    };
  };
}
