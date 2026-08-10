{...}: {
  imports = [
    ../shared/nix.nix # nixpkgs overlays + allowUnfree + nix settings (foundational)
    ./common
    ./homebrew
    # Disabled: sketchybar removed for now. Re-enable to bring it back.
    # ./sketchybar
  ];
}
