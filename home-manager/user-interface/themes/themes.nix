{
  config,
  pkgs,
  ...
}: {
  # Prefer dark mode and show all window decoration buttons
  dconf.settings = {
    "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
    "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";
  };

  # Cursor settings
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # GTK
  gtk = {
    enable = true;
    font = {
      package = pkgs.cantarell-fonts;
      name = "Cantarell";
      size = 11;
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Rosewater-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["rosewater"];
        variant = "mocha";
      };
    };
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.catppuccin-papirus-folders.override {
      flavor = "mocha";
      accent = "red";
    };
  };

  # Applies gtk theme
  home.sessionVariables = {
    GTK_THEME="Catppuccin-Mocha-Standard-Rosewater-Dark:dark";
  };

  # QT
  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };

  home.packages = with pkgs; [
    (catppuccin-kvantum.override {
      accent = "Rosewater";
      variant = "Mocha";
    })
  ];

  xdg.configFile = {
    # Links Kvantum configuration file
    "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {General.theme = "Catppuccin-Mocha-Rosewater";};
    "Kvantum/Catppuccin-Mocha-Rosewater".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Mocha-Rosewater";

    # Links gtk theme files
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };
}
