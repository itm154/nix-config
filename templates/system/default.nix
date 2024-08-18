{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  # Add modules to enable here

  # Enable Bootloader (EFI or BIOS)
  #system.boot.efi.enable = true;

  # Nvidia Drivers
  # hardware.nvidia.enable = true;

  # environment.systemPackages = with pkgs; [
  #   custom.package
  # ];

  system.stateVersion = "24.05";
}
