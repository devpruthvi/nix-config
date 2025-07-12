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

    # Source aerospace config from the home-manager store
    xdg.configFile."aerospace/aerospace.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/aerospace/aerospace.toml";
  };
}
