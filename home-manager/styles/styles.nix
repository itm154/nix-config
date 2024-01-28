{ config, pkgs, ... }: {
  # Prefer dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };

  # GTK
  gtk.enable = true;
  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3-dark";
  gtk.iconTheme.package = pkgs.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "red";
  };
  gtk.iconTheme.name = "Papirus-Dark";

  # QT
  qt.enable = true;
  qt.platformTheme = "gtk";
  qt.style.name = "kvantum";
  home.packages = with pkgs;
    [
      (catppuccin-kvantum.override {
        accent = "Rosewater";
        variant = "Mocha";
      })
    ];

  # This generates the required kvantim config file to set the current qt theme
  xdg.configFile."Kvantum/kvantum.kvconfig".source =
    (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
      General.theme = "Catppuccin-Mocha-Rosewater";
    };
}

