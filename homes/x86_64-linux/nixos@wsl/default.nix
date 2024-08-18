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

  cli.lazygit.enable = true;
}
