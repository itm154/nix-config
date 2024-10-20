{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.sddm;
in {
  options.desktop.addons.sddm = with types; {
    enable = mkBoolOpt true "Enable sddm";
    background = mkOption {
      type = types.path;
      default = ./background.jpg;
      description = "The background of sddm";
    };
  };

  config = mkIf cfg.enable {
    security.pam.services = {
      sddm.kwallet.enable = true;
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      # package = pkgs.kdePackages.sddm;
      theme = "catppuccin-mocha";
      extraPackages = [pkgs.libsForQt5.sddm-kcm];
    };

    environment.systemPackages = [
      (
        pkgs.catppuccin-sddm.override {
          flavor = "mocha";
          font = "JeBrainsMono Nerd Font";
          fontSize = "16";
          background = "${cfg.background}";
        }
      )
    ];
  };
}
