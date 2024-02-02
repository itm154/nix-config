{ config, pkgs, ...}: {
  programs.cava.enable = true;
  
  xdg.configFile."cava/mocha.cava".source = ./config/mocha.cava;
  xdg.configFile."cava/config".source = ./config/config;
  xdg.configFile."cava/config1".source = ./config/config1;
}

