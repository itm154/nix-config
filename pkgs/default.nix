# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs, ...}: {
  # example = pkgs.callPackage ./example { };
  cider = pkgs.callPackage ./cider.nix {};
  sddm-rose-pine = pkgs.callPackage ./sddm-rose-pine.nix {};
}
