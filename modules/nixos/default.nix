# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  battery-optimizations = import ./battery-optimizations;
  containers = import ./containers;
  core = import ./core;
  core-fonts = import ./core-fonts;
  gnome-apps = import ./gnome-apps;
  gnome-utils = import ./gnome-utils;
  icons-fix = import ./icons-fix;
  input-method-editor = import ./input-method-editor;
  networking = import ./networking;
  noisetorch = import ./noisetorch;
  nvidia = import ./nvidia;
  tablets = import ./tablets;
  wayland-core = import ./wayland-core;
}
