{
  lib,
  pkgs,
  ...
}: {
  config = {
    services.sketchybar = {
      enable = true;
      package = pkgs.sketchybar;
    };

    launchd.user.agents.sketchybar.serviceConfig = {
      StandardOutPath = "/tmp/sketchybar.log";
      StandardErrorPath = "/tmp/sketchybar.err.log";
    };
  };
}
