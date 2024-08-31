{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.starship;
in {
  options.cli.starship = with types; {
    enable = mkBoolOpt false "Enable module";
    fishIntegration = mkBoolOpt false "Enable fish integration";
    bashIntegration = mkBoolOpt false "Enable bash integration";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = cfg.fishIntegration;
      enableBashIntegration = cfg.bashIntegration;
      settings = {
        palette = "catppuccin-macchiato";

        palettes = {
          catppuccin-macchiato = {
            color_fg0 = "#cad3f5";
            color_bg1 = "#1e2030";
            color_bg3 = "#24273a";
            color_blue = "#8aadf4";
            color_aqua = "#91d7e3";
            color_green = "#a6da95";
            color_orange = "#f5a97f";
            color_purple = "#c6a0f6";
            color_red = "#ed8796";
            color_yellow = "#eed49f";
          };
        };

        format = "[](color_orange)\$username\[](bg:color_yellow fg:color_orange)\$directory\[](fg:color_yellow bg:color_aqua)\$git_branch\$git_status\[](fg:color_aqua bg:color_blue)\$c\$rust\$golang\$nodejs\$php\$java\$kotlin\$haskell\$python\[](fg:color_blue bg:color_bg3)\$docker_context\$conda\[](fg:color_bg3 bg:color_bg1)\$time\[ ](fg:color_bg1)\$line_break$character";

        os = {
          disabled = false;
          style = "bg:color_orange fg:color_bg1";
          symbols = {
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "󰀵";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "󰣇";
            Artix = "󰣇";
            EndeavourOS = "";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
          };
        };

        username = {
          show_always = true;
          style_user = "bg:color_orange fg:color_bg1";
          style_root = "bg:color_orange fg:color_bg1";
          format = "[ $user ]($style)";
        };

        directory = {
          style = "fg:color_bg1 bg:color_yellow";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            Documents = "󰈙 ";
            Downloads = " ";
            Music = "󰝚 ";
            Pictures = " ";
            Developer = "󰲋 ";
          };
        };

        git_branch = {
          symbol = "";
          style = "bg:color_aqua";
          format = "[[ $symbol $branch ](fg:color_bg1 bg:color_aqua)]($style)";
        };

        git_status = {
          style = "bg:color_aqua";
          format = "[[($all_status$ahead_behind )](fg:color_bg1 bg:color_aqua)]($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_bg1 bg:color_blue)]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_bg1 bg:color_blue)]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        php = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        java = {
          symbol = " ";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        kotlin = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        haskell = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        python = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        docker_context = {
          symbol = "";
          style = "bg:color_bg3";
          format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
        };

        conda = {
          style = "bg:color_bg3";
          format = "[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:color_bg1";
          format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
        };

        line_break = {
          disabled = false;
        };

        character = {
          disabled = false;
          success_symbol = "[](bold fg:color_green)";
          error_symbol = "[](bold fg:color_red)";
          vimcmd_symbol = "[](bold fg:color_green)";
          vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
          vimcmd_replace_symbol = "[](bold fg:color_purple)";
          vimcmd_visual_symbol = "[](bold fg:color_yellow)";
        };
      };
    };
  };
}
