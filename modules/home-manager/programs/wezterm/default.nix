{
  config,
  pkgs,
  dotfilesDir,
  ...
}: {
  home.packages = with pkgs; [wezterm];

  xdg.configFile = {
    "wezterm" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/wezterm";
      recursive = true;
    };
  };
}
