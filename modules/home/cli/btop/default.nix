{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.btop;
in {
  options.cli.btop = with types; {
    enable = mkBoolOpt false "Enable btop";
  };

  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "/home/${config.snowfallorg.user.name}/.config/btop/themes/catppuccin_mocha.theme";
        theme_background = false;
        vim_keys = true;
      };
    };

    home.file.".config/btop/themes" = {
      source = ./themes;
      recursive = true;
    };
  };
}
