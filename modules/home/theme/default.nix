{inputs, ...}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  # NOTE: Declare catppuccin.enable on each module cus im too lazy to fix clashes
  catppuccin.accent = "red";
  catppuccin.flavor = "mocha";
}
