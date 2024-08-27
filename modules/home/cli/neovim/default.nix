{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.neovim;
in {
  options.cli.neovim = with types; {enable = mkBoolOpt false "Enable neovim";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [inputs.neovim.packages.${system}.default];
    home.sessionVariables = {EDITOR = "nvim";};
  };
}
