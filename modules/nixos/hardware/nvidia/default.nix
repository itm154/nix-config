{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.nvidia;
in {
  options.hardware.nvidia = with types; {
    enable = mkBoolOpt false "Enable NVIDIA drivers";
    intelBusId = mkOpt str "" "Intel Bus ID";
    nvidiaBusId = mkOpt str "" "NVidia Bus ID";
    open-gpu-kernel-modules = mkBoolOpt false "Enable open gpu kernel modules";
  };

  config = mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;

      powerManagement = {
        enable = true;
        finegrained = true;
      };

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = cfg.intelBusId;
        nvidiaBusId = cfg.nvidiaBusId;
      };

      open = cfg.open-gpu-kernel-modules;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
