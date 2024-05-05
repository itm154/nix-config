{pkgs, ...}: {
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

      # The terminal colorscheme makes it hard to read, this launches alsamixer with it's stock colours
      mixer = "alsamixer --no-color";

      # Better ls
      ls = "${pkgs.eza}/bin/eza -al --color=always --group-directories-first";
      la = "${pkgs.eza}/bin/eza -a --color=always --group-directories-first";
      ll = "${pkgs.eza}/bin/eza -l --color=always --group-directories-first";
      lt = "${pkgs.eza}/bin/eza -aT --color=always --group-directories-first";
    };
  };
}
