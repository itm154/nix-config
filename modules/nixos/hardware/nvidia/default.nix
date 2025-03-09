{
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
    graphicsExtraPackages = mkOpt (listOf package) [] "Extra openGL packages";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = [pkgs.nvidia-vaapi-driver] ++ cfg.graphicsExtraPackages;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;

      # powerManagement = {
      #   enable = true;
      #   finegrained = true;
      # };

      # prime = {
      #   offload = {
      #     enable = true;
      #     enableOffloadCmd = true;
      #   };
      #
      #   intelBusId = cfg.intelBusId;
      #   nvidiaBusId = cfg.nvidiaBusId;
      # };

      nvidiaSettings = false;
      open = true;

      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
