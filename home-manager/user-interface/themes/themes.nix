{
  config,
  pkgs,
  ...
}: {
  # Prefer dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
  };

  # Cursor settings
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  # GTK
  gtk = {
    enable = true;
    font = {
      package = pkgs.cantarell-fonts;
      name = "Cantarell";
      size = 11;
    };
    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3-dark";
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.catppuccin-papirus-folders.override {
      flavor = "mocha";
      accent = "red";
    };
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

  # This generates the required kvantim config file to set the current qt theme
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
      General.theme = "Catppuccin-Mocha-Rosewater";
    };

    "Kvantum/Catppuccin-Mocha-Rosewater".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Mocha-Rosewater";
  };
}
