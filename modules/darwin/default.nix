{...}: {
  imports = [
    ../shared/nix.nix # nixpkgs overlays + allowUnfree + nix settings (foundational)
    ./common
    ./homebrew
    ./sketchybar
  ];
}
