{
  description = "My nix flake config based on snowfall-lib";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My own flakes
    neovim.url = "github:itm154/nixvim";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "dotfiles";
          title = "dotfiles";
        };
        namespace = "custom";
      };
    };
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };

      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };

      # NOTE: This is now declared in ./modules/nixos/home/default.nix
      # systems.modules.nixos = with inputs; [
      #   home-manager.nixosModules.home-manager
      # ];
    };
}
