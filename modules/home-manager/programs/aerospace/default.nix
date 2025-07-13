{
  config,
  lib,
  pkgs,
  dotfilesDir,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    # Ensure aerospace package installed
    home.packages = with pkgs; [
      aerospace
    ];

    xdg.configFile = {
      "aerospace" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/aerospace";
        recursive = true;
      };
    };
  };
}
