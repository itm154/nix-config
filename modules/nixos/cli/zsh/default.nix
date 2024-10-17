{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.zsh;
in {
  options.cli.zsh = with types; {
    enable = mkBoolOpt false "Enable zsh";
    aliasLs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable eza aliased to ls";
    };
    aliasCommonDir = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable aliases to common directory";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    users.users.${config.user.name} = {
      shell = pkgs.zsh;
    };

    home.extraOptions = {
      programs.zsh = {
        enable = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        historySubstringSearch.enable = true;
        shellAliases =
          lib.mkIf cfg.aliasCommonDir {
            rp = "cd ~/Repository/";
            dl = "cd ~/Downloads/";
            docs = "cd ~/Documents/";
          }
          // lib.mkIf cfg.aliasLs {
            ls = "${pkgs.eza}/bin/eza -al --color=always --group-directories-first";
            la = "${pkgs.eza}/bin/eza -a --color=always --group-directories-first";
            ll = "${pkgs.eza}/bin/eza -l --color=always --group-directories-first";
            lt = "${pkgs.eza}/bin/eza -aT --color=always --group-directories-first";
          }
          // {
            # The terminal colorscheme makes it hard to read, this launches alsamixer with its stock colours
            mixer = "alsamixer --no-color";
          };
      };
    };
  };
}
