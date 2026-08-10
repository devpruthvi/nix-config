{
  config,
  dotfilesDir,
  ...
}: {
  # Out-of-store symlink so $mod+Shift+c reloads live without a rebuild.
  xdg.configFile."i3/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/i3/config";
}
