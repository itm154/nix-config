{
  config,
  pkgs,
  ...
}: {
  cli = {
    git = {
      enable = true;
      username = "itm154";
      email = "ashrulfahmi@gmail.com";
    };

    gh.enable = true;

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
  };
}
