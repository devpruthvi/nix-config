{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (!pkgs.stdenv.isDarwin) {
    home.packages = [
      # Auto-pick Wayland under niri (avoids the XWayland focus-rescale "zoom" bug),
      # X11 under i3, safe across hosts.
      (pkgs.vivaldi.override {
        commandLineArgs = "--ozone-platform-hint=auto --enable-features=OverlayScrollbar";
      })
    ];
  };
}
