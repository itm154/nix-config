{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    # Window manager configuration
    ./window-manager
    ./user-interface
    ./programs
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "itm154";
    homeDirectory = "/home/itm154";
  };

  # Enable font settings
  fonts.fontconfig.enable = true;

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # Fonts
    source-sans
    source-serif
    source-han-sans
    source-han-mono
    source-han-serif
    corefonts
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })

    # Theming
    gradience

    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
