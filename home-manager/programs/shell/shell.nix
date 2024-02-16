{
  config,
  pkgs,
  ...
}: {
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
    shellAliases = {
      # Navigation
      rp = "cd ~/Repository/";
      dl = "cd ~/Downloads/";
      docs = "cd ~/Documents/";

      # Colorscheme made it hard to read the texts
      mixer = "alsamixer --no-color";

      # Better ls
      ls = "eza -al --color=always --group-directories-first";
      la = "eza -a --color=always --group-directories-first";
      ll = "eza -l --color=always --group-directories-first";
      lt = "eza -aT --color=always --group-directories-first";

      cd = "z";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings =
      {
        format = "$all";
        palette = "catppuccin_mocha";
      }
      // builtins.fromTOML (builtins.readFile (pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "starship";
          rev = "5629d23";
          sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
        }
        + /palettes/mocha.toml));
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
