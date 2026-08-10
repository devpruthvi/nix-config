# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  # Disabled: sketchybar removed for now. Re-enable alongside sketchybar.
  # sbar-lua = pkgs.callPackage ./sbar-lua {};
  # sbmenus = pkgs.callPackage ./sbmenus {};
}
