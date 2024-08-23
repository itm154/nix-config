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
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "itm154";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    inputs.neovim.packages.${system}.default
  ];

  system.stateVersion = "24.05";
}
