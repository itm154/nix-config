{ config, pkgs, ... }:
let
  launcher = pkgs.pkgs.writeShellScriptBin "rofi-launcher" ''
    ${pkgs.rofi-wayland}/bin/rofi -show drun -theme $HOME/.config/rofi/launcher/style.rasi
  '';
  powermenu = pkgs.pkgs.writeShellScriptBin "rofi-powermenu" ''
    
    uptime="`uptime -p | sed -e 's/up //g'`"
    host=`hostname`

# Options
    shutdown=''
    reboot=''
    lock=''
    suspend=''
    logout=''
    yes=''
    no=''

# Rofi CMD
    rofi_cmd() {
      ${pkgs.rofi-wayland}/bin/rofi -dmenu \
        -p "Uptime: $uptime" \
        -mesg "Uptime: $uptime" \
        -theme $HOME/.config/rofi/powermenu/style.rasi
    }

# Confirmation CMD
    confirm_cmd() {
      rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme $HOME/.config/rofi/powermenu/style.rasi
    }

# Ask for confirmation
    confirm_exit() {
      echo -e "$yes\n$no" | confirm_cmd
    }

# Pass variables to rofi dmenu
    run_rofi() {
      echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
    }

# Execute Command
    run_cmd() {
      selected="$(confirm_exit)"
      if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
          systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
          systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
          systemctl suspend
        elif [[ $1 == '--logout' ]]; then
          ${pkgs.hyprland}/bin/hyprctl dispatch exit
        fi
      else
        exit 0
      fi
    }

# Actions
    chosen="$(run_rofi)"
    case $${chosen} in
        $shutdown)
        run_cmd --shutdown
            ;;
        $reboot)
        run_cmd --reboot
            ;;
        $lock)
        if [[ -x '/usr/bin/betterlockscreen' ]]; then
          betterlockscreen -l
        elif [[ -x '/usr/bin/i3lock' ]]; then
          i3lock
        fi
            ;;
        $suspend)
        run_cmd --suspend
            ;;
        $logout)
        run_cmd --logout
            ;;
    esac
  '';
  Icomoon-Feather = pkgs.stdenv.mkDerivation {
    name = "Icomoon-Feather";
    dontUnpack = true;
    dontConfigure = true;
    src = pkgs.fetchurl {
      url = "https://github.com/adi1090x/rofi/raw/master/fonts/Icomoon-Feather.ttf";
      hash = "sha256-kKyBYq8r6+aL/vLWLgVqgTFjPWzGhYdqsMgmQhOBAVg=";
    };

    installPhase = ''
      mkdir -p $out/share/fonts/truetype/
      cp -R $src $out/share/fonts/truetype/
    '';
  };
in 
{
  programs.rofi.enable = true;
  programs.rofi.package = pkgs.rofi-wayland;
  
# Temporary, definitely would use the home manager module later but im too lazy right now
  home.file.".config/rofi" = {
    source = ./config;
    recursive = true;
  };

  home.packages = [ launcher powermenu Icomoon-Feather ];
}
