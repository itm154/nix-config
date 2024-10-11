{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.waybar;
  waybar-cava = pkgs.writeShellScriptBin "waybar-cava" ''
    is_cava_ServerExist=`ps -ef|grep -m 1 ${pkgs.cava}/bin/cava | grep -v "grep" | wc -l`
    if [ "$is_cava_ServerExist" = "0" ]; then
        echo "cava_server not found" > /dev/null 2>&1
    elif [ "$is_cava_ServerExist" = "1" ]; then
        ${pkgs.killall}/bin/killall cava
    fi

    exec ${pkgs.cava}/bin/cava -p ~/.config/cava/barConfig | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'
  '';
in {
  options.desktop.addons.waybar = with types; {
    enable = mkBoolOpt false "Enable waybar";
  };

  config = mkIf cfg.enable {
    home.extraOptions.programs.waybar.enable = true;

    home.extraOptions.programs.waybar.style = ''
          @define-color base   #1e1e2e;
          @define-color mantle #181825;
          @define-color crust  #11111b;

          @define-color text     #cdd6f4;
          @define-color subtext0 #a6adc8;
          @define-color subtext1 #bac2de;

          @define-color surface0 #313244;
          @define-color surface1 #45475a;
          @define-color surface2 #585b70;

          @define-color overlay0 #6c7086;
          @define-color overlay1 #7f849c;
          @define-color overlay2 #9399b2;

          @define-color blue      #89b4fa;
          @define-color lavender  #b4befe;
          @define-color sapphire  #74c7ec;
          @define-color sky       #89dceb;
          @define-color teal      #94e2d5;
          @define-color green     #a6e3a1;
          @define-color yellow    #f9e2af;
          @define-color peach     #fab387;
          @define-color maroon    #eba0ac;
          @define-color red       #f38ba8;
          @define-color mauve     #cba6f7;
          @define-color pink      #f5c2e7;
          @define-color flamingo  #f2cdcd;
          @define-color rosewater #f5e0dc;

          /* Global */
          * {
            font-family: JetBrainsMono Nerd Font;
            font-weight: bold;
          }

      #custom-sep {
            font-size: 18px;
            color: @surface1;
          }

      #custom-sep,
      #custom-playerctl,
      #custom-cava,
      #workspaces,
      #clock,
      #cpu,
      #memory,
      #wireplumber,
      #backlight,
      #network,
      #battery,
      #tray {
            padding: 5px 10px;
            border-style: solid;
            background-color: @base;
            opacity: 1;
            margin: 5px 0px 5px 0px;
          }

          window#waybar {
            background: rgba(30, 30, 46, 0.5);
            color: @base;
          }

          /* END-Global */

          /* Left */
      #workspaces {
            background: @base;
            border-radius: 12px;
          }

      #workspaces button {
            border-radius: 16px;
            color: @surface1;
          }

      #workspaces button.active {
            color: @pink;
            background-color: transparent;
            border-radius: 16px;
          }

      #workspaces button:hover {
            background-color: @pink;
            color: @base;
            border-radius: 100%;
          }

      #custom-cava {
            border-radius: 12px;
            color: @blue;
          }

      #custom-playerctl {
            border-radius: 12px;
            margin-left: 10px;
            padding-left: 10px;
            padding-right: 10px;
            color: @text;
          }

          /* END-Left */

          /* Middle */
      #clock {
            color: @sky;
            border-radius: 12px;
            margin-left: 10px;
            margin-right: 10px;
            padding-left: 10px;
            padding-right: 10px;
          }

          /* END-Middle */

          /* Right */
      #tray {
            border-radius: 12px;
            margin-right: 10px;
            padding-left: 10px;
            padding-right: 10px;
          }

      #cpu {
            color: @lavender;
            border-radius: 10px 0 0 10px;
          }

      #memory {
            color: @mauve;
          }

      #wireplumber {
            color: @peach;
          }

      #backlight {
            color: @yellow;
            border-radius: 0 10px 10px 0;
            margin-right: 10px;
          }

      #battery {
            color: @sapphire;
            border-radius: 10px 0 0 10px;
          }

      #battery.charging {
            color: @yellow;
          }

          @keyframes blink {
            to {
              color: @red;
            }
          }

      #battery.critical:not(.charging) {
            color: @red;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

      #network {
            color: @green;
            border-radius: 0 10px 10px 0;
            margin-right: 10px;
          }

          /* END-Right */
    '';

    home.extraOptions.programs.waybar.settings = [
      {
        "layer" = "top";
        "position" = "top";
        modules-left = ["clock" "custom/cava" "custom/playerctl"];
        modules-center = ["hyprland/workspaces"];
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "custom/sep"
          "wireplumber"
          "backlight"
          "battery"
          "network"
        ];
        "custom/sep" = {
          "format" = "󰇙";
          "tooltip" = false;
        };
        "hyprland/workspaces" = {
          "active-only" = false;
          "all-outputs" = true;
          "disable-scroll" = false;
          "on-scroll-up" = "${pkgs.hyprland}/bin/hyprctl dispatch workspace -1";
          "on-scroll-down" = "${pkgs.hyprland}/bin/hyprctl dispatch workspace +1";
          "format" = "{icon}";
          "on-click" = "activate";
          "format-icons" = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "sort-by-number" = true;
          };
        };
        "custom/playerctl" = {
          "format" = "{icon}  <span>{}</span>";
          "return-type" = "json";
          "max-length" = 35;
          "exec" = ''
            ${pkgs.playerctl}/bin/playerctl -a metadata --format '{"text": "{{artist}} ~ {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          "on-click-middle" = "${pkgs.playerctl}/bin/playerctl play-pause";
          "on-click" = "${pkgs.playerctl}/bin/playerctl previous";
          "on-click-right" = "${pkgs.playerctl}/bin/playerctl next";
          "format-icons" = {
            "Playing" = "<span foreground='#a6e3a1'></span>";
            "Paused" = "<span foreground='#f38ba8'></span>";
          };
          "tooltip" = false;
        };
        "custom/cava" = {
          "exec" = "${waybar-cava}/bin/waybar-cava";
          "format" = "{}";
          "layer" = "below";
          "output" = "all";
          "tooltip" = false;
        };
        "clock" = {
          "format" = "  {:%R %p} ";
          "format-alt" = "  {:%A 󰇙 %d %B} ";
          "tooltip" = false;
        };
        "tray" = {
          "icon-size" = 21;
          "spacing" = 10;
          "tooltip" = false;
        };
        "cpu" = {
          "format" = "󰻠 {usage}%";
          "tooltip" = false;
        };
        "memory" = {
          "format" = " {used:0.1f}G";
          "tooltip" = false;
        };
        "wireplumber" = {
          "scroll-step" = 5;
          "format" = "{icon} {volume}";
          "format-bluetooth" = "󰂯{icon} {volume}";
          "format-muted" = " ";
          "format-bluetooth-muted" = "󰂯 ";
          "format-icons" = {"default" = ["" "" " "];};
          # "on-click-middle" = "${pkgs.pw-volume}/bin/pw-volume mute toggle; pkill -RTMIN+8 waybar";
          # "on-scroll-up" = "${pkgs.pw-volume}/bin/pw-volume change +5%; pkill -RTMIN+8 waybar";
          # "on-scroll-down" = "${pkgs.pw-volume}/bin/pw-volume change -5%; pkill -RTMIN+8 waybar";
          # "max-volume" = 100;
          "tooltip" = false;
        };
        "backlight" = {
          "scroll-step" = 5;
          "format" = "{icon} {percent}";
          "format-icons" = ["" "" "" "" "" "" "" "" ""];
          "on-scroll-up" = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          "on-scroll-down" = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "tooltip" = false;
        };
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon} {capacity}%";
          "format-charging" = "󰂄 {capacity}%";
          "format-good" = "{capacity}%";
          "format-icons" = ["󰁻" "󰁽 " "󰁿" "󰂁" "󰁹"];
          "tooltip" = false;
        };
        "network" = {
          "format-linked" = "{ifname} (No IP) ";
          "format-wifi" = " ";
          "format-ethernet" = "󰈀 ";
          "format-disabled" = "󰌙 ";
          "format-disconnected" = "󰌙 ";
          "format-alt" = "{essid}: {ipaddr}/{cidr}";
          "tooltip" = false;
        };
      }
    ];

    environment.systemPackages = [waybar-cava];
  };
}
