{pkgs, ...}: {
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
}
