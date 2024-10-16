{
  config,
  pkgs,
  ...
}: {
  cli = {
    git = {
      useGithubCli = true;
      enable = true;
      username = "itm154";

      email = "ashrulfahmi@gmail.com";
    };

    zoxide = {
      enable = true;
      fishIntegration = true;
      aliasCd = true;
    };

    starship = {
      enable = true;
      fishIntegration = true;
    };

    lazygit.enable = true;
    yazi.enable = true;
    btop.enable = true;
    bat.enable = true;
    cava.enable = true;

    neovim.enable = true;
  };
}
