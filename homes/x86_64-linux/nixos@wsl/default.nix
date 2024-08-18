{
  config,
  pkgs,
  ...
}: {
  cli.git = {
    enable = true;
    username = "itm154";
    email = "ashrulfahmi@gmail.com";
  };

  cli.gh.enable = true;

  cli.zoxide = {
    enable = true;
    fishIntegration = true;
    aliasCd = true;
  };

  cli.fish = {
    enable = true;
    aliasCommonDir = true;
    aliasLs = true;
  };

  cli.lazygit.enable = true;
}
