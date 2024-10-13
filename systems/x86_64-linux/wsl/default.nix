{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.default
  ];

  cli = {
    fish.enable = true;
  };

  wsl.enable = true;
  wsl.defaultUser = "itm154";
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.05";
}
