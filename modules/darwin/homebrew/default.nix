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

        # Sketchybar stuff (disabled, re-enable with sketchybar)
        # "sf-symbols"
        # "font-sf-mono"
        # "font-sf-pro"

        "keepingyouawake"

        "omniwm"
      ];
    };
  };
}
