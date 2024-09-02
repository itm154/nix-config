{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.looking-glass-client;
  user = config.user;
in {
  options.apps.looking-glass-client = with types; {
    enable = mkBoolOpt false "Whether or not to enable the Looking Glass client.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [looking-glass-client];

    environment.etc."looking-glass-client.ini" = {
      user = "+${toString config.users.users.${user.name}.uid}";
      source = ./client.ini;
    };
  };
}
