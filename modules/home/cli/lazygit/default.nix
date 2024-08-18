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
      settings = {
        gui = {
          showIcons = true;
          showBottomLine = false;
          theme = {
            lightTheme = false;
            activeBorderColor = ["#a6e3a1" "bold"];
            inactiveBorderColor = ["#cdd6f4"];
            optionsTextColor = ["#89b4fa"];
            selectedLineBgColor = ["#313244"];
            selectedRangeBgColor = ["#313244"];
            cherryPickedCommitBgColor = ["#94e2d5"];
            cherryPickedCommitFgColor = ["#89b4fa"];
            unstagedChangesColor = ["red"];
          };
        };
      };
    };
  };
}
