{
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    homebrew = {
      enable = true;
      casks = [
        "pearcleaner"
        "raycast"
        "google-chrome"
        "vivaldi"

        # Sketchybar stuff
        "sf-symbols"
        "font-sketchybar-app-font"
        "font-sf-mono"
        "font-sf-pro"
      ];
    };
  };
}
