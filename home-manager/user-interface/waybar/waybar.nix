{ config, pkgs, ... }:
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
in {
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;

  # xdg.configFile."waybar/config.jsonc".source = ./config/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./config/style.css;
  xdg.configFile."waybar/mocha.css".source = ./config/mocha.css;
  # xdg.configFile."waybar/scripts/cava.sh".source = ./config/scripts/cava.sh;
  
  xdg.configFile."waybar/config.json".source = ''
    {
      "layer": "top",
      "position": "top",
      "modules-left": ["clock", "custom/cava", "custom/playerctl"],
      "modules-center": ["hyprland/workspaces"],
      "modules-right": [
        "tray",
        "cpu",
        "memory",
        "custom/sep",
        "pulseaudio",
        "backlight",
        "battery",
        "network"
      ],
      "custom/sep": {
        "format": "󰇙",
        "tooltip": false
      },
      "hyprland/workspaces": {
        "active-only": false,
        "all-outputs": true,
        "disable-scroll": false,
        "on-scroll-up": "hyprctl dispatch workspace -1",
        "on-scroll-down": "hyprctl dispatch workspace +1",
        "format": "{icon}",
        "on-click": "activate",
        "format-icons": {
          "1": "一",
          "2": "二",
          "3": "三",
          "4": "四",
          "5": "五",
          "6": "六",
          "sort-by-number": true
        }
      },
      "custom/playerctl": {
        "format": "{icon}  <span>{}</span>",
        "return-type": "json",
        "max-length": 35,
        "exec": "${pkgs.playerctl}/bin/playerctl -a metadata --format '{\"text\": \"{{artist}} ~ {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F",
        "on-click-middle": "${pkgs.playerctl}/bin/playerctl play-pause",
        "on-click": "${pkgs.playerctl}/bin/playerctl previous",
        "on-click-right": "${pkgs.playerctl}/bin/playerctl next",
        "format-icons": {
          "Playing": "<span foreground='#a6e3a1'></span>",
          "Paused": "<span foreground='#f38ba8'></span>"
        },
        "tooltip": false
      },
      "custom/cava": {
        "exec": "sh ~/.config/waybar/scripts/cava.sh",
        "format": "{}",
        "layer": "below",
        "output": "all",
        "tooltip": false
      },
      "clock": {
        "format": "  {:%I:%M %p} ",
        "format-alt": "  {:%A 󰇙 %d %B} ",
        "tooltip": false
      },
      "tray": {
        "icon-size": 21,
        "spacing": 10,
        "tooltip": false
      },
      "cpu": {
        "format": "󰻠 {usage}%",
        "tooltip": false
      },
      "memory": {
        "format": " {used:0.1f}G",
        "tooltip": false
      },
      "pulseaudio": {
        "scroll-step": 5,
        "format": "{icon} {volume}",
        "format-bluetooth": "{icon} {volume}",
        "format-muted": " ",
        "format-bluetooth-muted": " ",
        "format-icons": {
          "default": ["", "", " "]
        },
        "on-click-middle": "${pkgs.alsa-utils}/bin/amixer -D pulse set Master 1+ toggle",
        "on-scroll-up": "${pkgs.pamixer}/bin/pamixer -i 5",
        "on-scroll-down": "${pkgs.pamixer}/bin/pamixer -d 5",
        "tooltip": false
      },
      "backlight": {
        "scroll-step": 5,
        "format": "{icon} {percent}",
        "format-icons": ["", "", "", "", "", "", "", "", ""],
        "tooltip": false
      },
      "battery": {
        "states": {
          "warning": 30,
          "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": "󰂄 {capacity}%",
        "format-good": "{capacity}%",
        "format-icons": ["󰁻", "󰁽 ", "󰁿", "󰂁", "󰁹"],
        "tooltip": false
      },
      "network": {
        "format-linked": "{ifname} (No IP) ",
        "format-wifi": " ",
        "format-ethernet": " ",
        "format-disabled": "󰌙 ",
        "format-disconnected": "睊 ",
        "format-alt": "{essid}: {ipaddr}/{cidr}",
        "tooltip": false
      }
    }
  ''
  home.packages = [ waybar-cava ];
}
