{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.user;

  home-directory = "/home/${config.snowfallorg.user.name}";
in {
  options.user = with types; {
    enable = mkBoolOpt true "Whether to configure the user account";
    name = mkOpt (types.nullOr types.str) (config.snowfallorg.user.name or "itm154") "User account name";
    email = mkOpt types.str "" "User email";
    home = mkOpt (types.nullOr types.str) home-directory "User home directory";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "user.name must be set";
        }
        {
          assertion = cfg.home != null;
          message = "user.home must be set";
        }
      ];

      home = {
        username = mkDefault cfg.name;
        homeDirectory = mkDefault cfg.home;
      };
    }
  ]);
}
