{
  config,
  pkgs,
  dotfilesDir,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      font-size = 13;
      mouse-hide-while-typing = true;
      focus-follows-mouse = true;
      shell-integration = "detect";
      shell-integration-features = true;
      window-inherit-working-directory = true;
      window-theme = "ghostty";
      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-trim-trailing-spaces = true;
      copy-on-select = true;
      custom-shader = "${config.xdg.configHome}/ghostty/shaders/cursor_warp.glsl";
    };
  };

  stylix.targets.ghostty.enable = true;

  xdg.configFile."ghostty/shaders/cursor_warp.glsl".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/sahaj-b/ghostty-cursor-shaders/main/cursor_warp.glsl";
    sha256 = "1qadq5pyiihfc3zima3701d00gczshqycb4q4ipzrj29s3gkm93m";
  };
}
