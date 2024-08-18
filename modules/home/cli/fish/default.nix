{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.fish;
in {
  options.cli.fish = with types; {
    enable = mkBoolOpt false "Enable module";
    aliasLs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable eza aliased to ls";
    };
    aliasCommonDir = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable aliases to common directory";
    };
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      plugins = [
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "bang-bang";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-bang-bang";
            rev = "ec991b8";
            sha256 = "sha256-oPPCtFN2DPuM//c48SXb4TrFRjJtccg0YPXcAo0Lxq0=";
          };
        }
      ];
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

      functions = {
        yy = {
          body = ''
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file="$tmp"
            if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              cd -- "$cwd"
            end
            rm -f -- "$tmp"
          '';
        };
      };
    };
  };
}
