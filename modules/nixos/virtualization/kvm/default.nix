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
in {
  options.virtualisation.kvm = with types; {
    enable = mkBoolOpt false "Whether or not to enable KVM virtualisation.";
    vfioIds =
      mkOpt (listOf str) []
      "The hardware IDs to pass through to a virtual machine.";
    platform =
      mkOpt (enum ["amd" "intel"]) "intel"
      "Which CPU platform the machine is using.";
    # Use `machinectl` and then `machinectl status <name>` to
    # get the unit "*.scope" of the virtual machine.
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
          ovmf.enable = true;
          ovmf.packages = [
            (pkgs.OVMFFull.override {
              # I have to build UEFI firmware from source, fun times
              secureBoot = true; # Win 11 needs secure boot
              tpmSupport = true; # Win 11 needs TPM
            })
            .fd
          ];
          swtpm.enable = true;
          # verbatimConfig = ''
          #   namespaces = []
          #   user = "+${toString config.users.users.${user.name}.uid}"
          # '';
        };
      };
    };

    # NOTE: This is probably a workaround when virt-manager doesnt see a secure boot ovmf bios
    # environment.etc = {
    #   "ovmf/edk2-x86_64-secure-code.fd" = {
    #     source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    #   };
    #
    #   "ovmf/edk2-i386-vars.fd" = {
    #     source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
    #   };
    # };

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
