{
  lib,
  pkgs,
  ...
}: {
  config = {
    services.sketchybar = {
      enable = false;
      package = pkgs.sketchybar;
    };

    launchd.user.agents.sketchybar.serviceConfig = {
      StandardOutPath = "/tmp/sketchybar.log";
      StandardErrorPath = "/tmp/sketchybar.err.log";
    };
  };
}
