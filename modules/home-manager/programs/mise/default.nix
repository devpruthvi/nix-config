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

    home.sessionPath = [
      "${config.home.homeDirectory}/.local/share/mise/shims"
    ];

    xdg.configFile = {
      "mise" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/mise";
        recursive = true;
      };
    };
  };
}
