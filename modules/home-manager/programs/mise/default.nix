{
  config,
  lib,
  pkgs,
  dotfilesDir,
  ...
}: {
  config = {
    programs.mise = {
      enable = true;
    };

    xdg.configFile = {
      "mise" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/mise";
        recursive = true;
      };
    };
  };
}
