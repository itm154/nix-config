{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./window-manager
    ./user-interface
    ./programs
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # Minecraft
      inputs.prismlauncher.overlays.default

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
    # Theming
    gradience

    # Use Vesktop flatpak instead
    # See https://github.com/NixOS/nixpkgs/issues/195512
    # (pkgs.discord.override {
    #   withOpenASAR = true;
    #   withVencord = true;
    # })

    # Gaming
    steam
    gamescope
    protonup-qt
    protontricks
    winetricks
    prismlauncher

    # Font
    (pkgs.nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono" "CascadiaCode" "Monaspace" "IBMPlexMono"];})

    # Discord
    unstable.vesktop
    arrpc
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # EasyEffects
  services.easyeffects = {
    enable = true;
    preset = "Noise Reduction";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
