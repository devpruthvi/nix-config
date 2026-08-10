{
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    homebrew = {
      enable = true;
      taps = [
        "BarutSRB/tap"
      ];
      brews = [
        # OmniWM.app + omniwmctl CLI
        "omniwm"
      ];
      casks = [
        "pearcleaner"
        "raycast"
        "google-chrome"
        "vivaldi"

        # Sketchybar stuff
        "sf-symbols"
        "font-sf-mono"
        "font-sf-pro"

        "keepingyouawake"
      ];
    };
  };
}
