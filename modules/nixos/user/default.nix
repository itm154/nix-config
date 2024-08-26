{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.user;
  defaultIconFileName = "profile.jpeg";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = {fileName = defaultIconFileName;};
  };
  propagatedIcon =
    pkgs.runCommandNoCC "propagated-icon"
    {passthru = {inherit (cfg.icon) fileName;};}
    ''
      local target="$out/share/icons/user/${cfg.name}"
      mkdir -p "$target"

      cp ${cfg.icon} "$target/${cfg.icon.fileName}"
    '';
in {
  options.user = with types; {
    name = mkOpt str "itm154" "The name to use for the user account.";
    initialPassword =
      mkOpt str "12345678"
      "The initial password to use when the user is first created.";
    icon =
      mkOpt (nullOr package) defaultIcon
      "The profile picture to use for the user.";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions =
      mkOpt attrs {}
      "Extra options passed to <option>users.users.<name></option>.";
  };

  config = {
    environment.systemPackages = with pkgs; [
      propagatedIcon
    ];

    environment.sessionVariables.FLAKE = "/home/itm154/Repository/nix-config";

    home = {
      file = {
        "Pictures/${
          cfg.icon.fileName or (builtins.baseNameOf cfg.icon)
        }".source =
          cfg.icon;
      };
    };

    users.users.${cfg.name} =
      {
        isNormalUser = true;
        inherit (cfg) name initialPassword;
        home = "/home/${cfg.name}";
        group = "users";

        extraGroups =
          ["wheel" "audio" "sound" "video" "networkmanager" "input" "tty"]
          ++ cfg.extraGroups;
      }
      // cfg.extraOptions;

    users.mutableUsers = false;
  };
}
