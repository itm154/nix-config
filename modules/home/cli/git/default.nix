{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.git;
in {
  options.cli.git = with types; {
    enable = mkBoolOpt false "Enable git";
    useGithubCli = mkBoolOpt false "Enable github cli for authentication";
    username = mkOpt types.str null "Username";
    email = mkOpt types.str null "Email";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;

      userName = cfg.username;
      userEmail = cfg.email;
    };
    programs.gh = mkIf cfg.useGithubCli {
      enable = true;
    };
  };
}
