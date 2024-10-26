{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.virtualisation.kvm;
  inherit (config) user;

  # Helper commands for information, attaching and detaching nvidia gpu
  hows-my-gpu = pkgs.pkgs.writeShellScriptBin "hows-my-gpu" ''
    echo "NVIDIA Dedicated Graphics" | grep "NVIDIA" && lspci -nnk | grep "NVIDIA Corporation AD107M" -A 2 | grep "Kernel driver in use" && echo "Intel Integrated Graphics" | grep "Intel" && lspci -nnk | grep "Intel.*Integrated Graphics Controller" -A 3 | grep "Kernel driver in use" && echo "Enable and disable the dedicated NVIDIA GPU with nvidia-enable and nvidia-disable"
  '';
  nvidia-enable = pkgs.pkgs.writeShellScriptBin "nvidia-enable" ''
    sudo virsh nodedev-reattach pci_0000_01_00_0 && echo "GPU reattached (now host ready)" && sudo rmmod vfio_pci vfio_pci_core vfio_iommu_type1 && echo "VFIO drivers removed" && sudo modprobe -i nvidia_modeset nvidia_uvm nvidia && echo "NVIDIA drivers added" && echo "COMPLETED!"
  '';
  nvidia-disable = pkgs.pkgs.writeShellScriptBin "nvidia-disable" ''
    sudo rmmod nvidia_modeset nvidia_uvm nvidia && echo "NVIDIA drivers removed" && sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1 && echo "VFIO drivers added" && sudo virsh nodedev-detach pci_0000_01_00_0 && echo "GPU detached (now vfio ready)" && echo "COMPLETED!"
  '';
in {
  options.virtualisation.kvm = with types; {
    enable = mkBoolOpt false "Whether or not to enable KVM virtualisation.";
    vfioIds =
      mkOpt (listOf str) []
      "The hardware IDs to pass through to a virtual machine.";
    platform =
      mkOpt (enum ["amd" "intel"]) "intel"
      "Which CPU platform the machine is using.";
    # Use `machinectl` and then `machinectl status <name>` to get the unit "*.scope" of the virtual machine.
    machineUnits =
      mkOpt (listOf str) []
      "The systemd *.scope units to wait for before starting Scream.";
  };

  config = mkIf cfg.enable {
    apps.looking-glass-client.enable = true;

    boot = {
      kernelModules = [
        "kvm-${cfg.platform}"
        "vfio_virqfd"
        "vfio_pci"
        "vfio_iommu_type1"
        "vfio"
      ];
      kernelParams = [
        "${cfg.platform}_iommu=on"
        "${cfg.platform}_iommu=pt"
        "kvm.ignore_msrs=1"
      ];
      extraModprobeConfig =
        optionalString (length cfg.vfioIds > 0)
        "options vfio-pci ids=${concatStringsSep "," cfg.vfioIds}";
    };

    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${user.name} qemu-libvirtd -"
      "f /dev/shm/scream 0660 ${user.name} qemu-libvirtd -"
    ];

    environment.systemPackages = with pkgs; [
      libtpms
      nvidia-enable
      nvidia-disable
      hows-my-gpu
      pciutils
    ];

    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd = {
        enable = true;
        # extraConfig = ''
        #   user="${user.name}"
        # '';

        onBoot = "ignore";
        onShutdown = "shutdown";

        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
          runAsRoot = true;
          # verbatimConfig = ''
          #   namespaces = []
          #   user = "+${builtins.toString config.users.users.${user.name}.uid}"
          # '';
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              })
              .fd
            ];
          };
        };
      };
    };

    user = {extraGroups = ["qemu-libvirtd" "libvirtd" "disk"];};

    home.extraOptions = {
      systemd.user.services.scream = {
        Unit.Description = "Scream";
        Unit.After =
          [
            "libvirtd.service"
            "pipewire-pulse.service"
            "pipewire.service"
            "sound.target"
          ]
          ++ cfg.machineUnits;
        Service.ExecStart = "${pkgs.scream}/bin/scream -n scream -o pulse -m /dev/shm/scream";
        Service.Restart = "always";
        Service.StartLimitIntervalSec = "5";
        Service.StartLimitBurst = "1";
        Install.RequiredBy = cfg.machineUnits;
      };
    };
  };
}
