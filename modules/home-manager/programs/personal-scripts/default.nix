{
  config,
  pkgs,
  dotfilesDir,
  ...
}: {
  xdg.configFile = {
    "personalscripts" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/personal-scripts";
      recursive = true;
    };
  };
}
