{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.zoxide;
in {
  options.cli.zoxide = with types; {
    enable = mkBoolOpt false "Enable zoxide";
    bashIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable bash integration";
    };
    fishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fish integration";
    };
    nuShellIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nushell integration";
    };
    zshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable zsh integration";
    };
    aliasCd = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Alias cd to zoxide";
    };
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = cfg.bashIntegration;
      enableFishIntegration = cfg.fishIntegration;
      enableNushellIntegration = cfg.nuShellIntegration;
      enableZshIntegration = cfg.zshIntegration;
      options =
        if cfg.aliasCd
        then ["--cmd cd"]
        else [];
    };
  };
}
