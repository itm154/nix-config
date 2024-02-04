{ config, pkgs, ... }: {
  home.file.".config/swaync" = {
    source = ./config;
    recursive = true;
  };
}

