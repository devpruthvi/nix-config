{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Register flake inputs for nix commands
  nix.registry = lib.mapAttrs (_: flake: {inherit flake;}) (lib.filterAttrs (_: lib.isType "flake") inputs);

  # Nix settings
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = pkgs.stdenv.isLinux;
  };

  nix.optimise.automatic = pkgs.stdenv.isDarwin;

  # Garbage collection
  nix.gc = lib.mkIf pkgs.stdenv.isLinux {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
