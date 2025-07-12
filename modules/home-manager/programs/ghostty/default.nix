{
  config,
  pkgs,
  dotfilesDir,
  ...
}: {
  home.packages = with pkgs; [
    (
      if stdenv.isDarwin
      then ghostty-bin
      else ghostty
    )
  ];

  xdg.configFile."ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/ghostty/config";
}
