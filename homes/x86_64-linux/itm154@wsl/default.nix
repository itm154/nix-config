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

    fish = {
      enable = true;
      aliasCommonDir = true;
      aliasLs = true;
    };

    starship = {
      enable = true;
      fishIntegration = true;
    };

    lazygit.enable = true;
    yazi.enable = true;
    btop.enable = true;

    neovim.enable = true;
  };
}
