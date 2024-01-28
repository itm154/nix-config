{ config, pkgs, ...}: {
 gtk.enable = true;

 gtk.theme.package = pkgs.adw-gtk3;
 gtk.theme.name = "adw-gtk3";

 gtk.iconTheme.package = pkgs.catppuccin-papirus-folders.override {
   flavor = "mocha";
   accent = "red";
 };
 gtk.iconTheme.name = "Papirus-Dark";
}
  
