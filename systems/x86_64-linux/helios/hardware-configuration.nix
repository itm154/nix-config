# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  # NOTE: These modules can only be used with the zen kernel because the regular nix kernel does breaks sof-firmware/audio
  acer-module = pkgs.custom.acer-module;
  acer-wmi-battery = pkgs.custom.acer-wmi-battery;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # WARNING:Things required for my laptop to work properly, never change this
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # NOTE: Look at the top comment
  boot.extraModulePackages = [acer-module acer-wmi-battery];
  boot.kernelModules = ["kvm-intel" "facer" "wmi" "sparse-keymap" "video" "acer-wmi-battery"];

  boot.initrd.kernelModules = [];
  boot.initrd.availableKernelModules = ["vmd" "xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9bdb9b9d-cf93-41f2-85d3-3a6f3d30d48e";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B31F-388F";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/65f8363e-5f07-4699-be22-1ebf71314f48";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp109s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Actual Hardware config
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.firmware = with pkgs; [
    sof-firmware # NOTE: This is just to explicitly declare sof-firmware because it doesn't work sometimes
  ];

  # NOTE: This is hardware config from the custom nixos modules, moved it here because it is more fitting
  hardware = {
    audio.enable = true;
    batteryOptimization.enable = true;
    bluetooth.enable = true;
    drawingTablet.enable = true;
    networking.enable = true;
    nvidia = {
      enable = true;
      openglExtraPackages = with pkgs; [intel-media-driver];
      intelBusId = "PCI:1:0:0";
      nvidiaBusId = "PCI:0:2:0";
    };
  };
}
