{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.lazygit;
in {
  options.cli.lazygit = with types; {
    enable = mkBoolOpt false "Enable module";
  };

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      catppuccin.enable = true;
      settings = {
        gui = {
          showIcons = true;
          showBottomLine = false;
        };
      };
    };
  };
}
