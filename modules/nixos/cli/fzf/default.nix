{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.fzf;
in {
  options.cli.fzf = with types; {
    enable = mkBoolOpt false "Enable fzf";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.fzf
    ];

    programs.fzf = {
      fuzzyCompletion = true;
    };

    home.extraOptions.programs.fzf = {
      enable = true;
      catppuccin.enable = true;
    };
  };
}
