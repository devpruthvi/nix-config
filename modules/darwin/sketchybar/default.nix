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
  };
}
