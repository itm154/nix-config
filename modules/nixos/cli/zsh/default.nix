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
    useEza = mkBoolOpt true "Alias ls to use eza instead";
    aliasCommonDir = mkBoolOpt true "Alias common directories";
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    users.users.${config.user.name} = {
      shell = pkgs.zsh;
    };

    # Home-manager options
    home.extraOptions.programs.zsh = {
      enable = true;

      # This options are here to make zsh as similar to fish as possible
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;

      shellAliases =
        lib.mkIf cfg.aliasCommonDir {
          rp = "cd ~/Repository/";
          dl = "cd ~/Downloads/";
          docs = "cd ~/Documents/";
        }
        // lib.mkIf cfg.useEza {
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
}
