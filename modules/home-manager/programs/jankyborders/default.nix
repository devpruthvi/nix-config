{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    services.jankyborders = {
      enable = true;
      settings = {
        style = "round";
        active_color = "0xc0${config.lib.stylix.colors.base0E}";
        inactive_color = "0xc0${config.lib.stylix.colors.base02}";
        background_color = "0x30${config.lib.stylix.colors.base00}";
        width = 6;
        ax_focus = false;
        hidpi = false;
      };
    };
  };
}
