{
  config,
  pkgs,
  ...
}: {
  # NOTE: CLI programs
  cli = {
    # Git stuff
    lazygit.enable = true;
    git = {
      useGithubCli = true;
      enable = true;
      username = "itm154";

      email = "ashrulfahmi@gmail.com";
    };

    starship = {
      enable = true;
      # fishIntegration = true;
      zshIntegration = true;
    };

    # Some cli stuff
    yazi.enable = true;
    btop.enable = true;
    bat.enable = true;
    cava.enable = true;
    zoxide = {
      enable = true;
      # fishIntegration = true;
      zshIntegration = true;
      aliasCd = true;
    };

    # Main editor
    neovim.enable = true;
  };

  # NOTE:GUI apps
  apps = {
    kitty.enable = true;
  };

  home.packages = with pkgs; [
    custom.cider
  ];
}
