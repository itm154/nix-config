{
  options,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.software.containers;
in {
  options.software.containers = {
    enable = mkEnableOption "Enable docker/podman";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = false;
    virtualisation.docker.storageDriver = "btrfs";
    virtualisation.podman.enable = true;
    virtualisation.podman.dockerSocket.enable = true;
    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    environment.systemPackages = [pkgs.docker-client];
  };
}
