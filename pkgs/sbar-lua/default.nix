{lib, pkgs, stdenv, ...}:
with lib;
    stdenv.mkDerivation {
    pname = "SketchyBarLua";
    version = "unstable-2024-08-12"; # Use a specific tag or commit hash if desired
    src = pkgs.fetchFromGitHub {
      owner = "FelixKratz";
      repo = "SbarLua";
      rev = "437bd2031da38ccda75827cb7548e7baa4aa9978"; # Replace with a specific commit or tag for stability.
      sha256 = "sha256-F0UfNxHM389GhiPQ6/GFbeKQq5EvpiqQdvyf7ygzkPg=";
    };

    buildInputs = with pkgs;
    [
      gcc
      readline
    ];

    buildPhase = ''
        make bin/sketchybar.so
    '';

    installPhase = ''
      mkdir -p $out/lib
      mv bin/sketchybar.so $out/lib/sketchybar.so
    '';
}

