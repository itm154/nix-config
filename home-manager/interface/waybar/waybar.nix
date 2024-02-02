{ config, pkgs, ...}:
let
# This script is used for waybar's cava module
  waybar-cava = pkgs.writeShellScriptBin "waybar_cava" ''
    is_cava_ServerExist=`ps -ef|grep -m 1 ${pkgs.cava}/bin/cava | grep -v "grep"|wc -l`
    if [ "$is_cava_ServerExist" = "0" ]; then
        echo "cava_server not found" > /dev/null 2>&1
        #	exit;
    elif [ "$is_cava_ServerExist" = "1" ]; then
        killall cava
    fi

    exec ${pkgs.cava}/bin/cava -p ~/.config/cava/config1 | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'
  '';
in
{
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;

  # TODO: Rewrite configuration using the waybar home manager module
  xdg.configFile."waybar/config.jsonc".source = ./config/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./config/style.css;
  xdg.configFile."waybar/mocha.css".source = ./config/mocha.css;
  # xdg.configFile."waybar/scripts/cava.sh".source = ./config/scripts/cava.sh;

  home.packages = [ waybar-cava ];
}
