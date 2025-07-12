{pkgs, ...}: {
  home.packages = with pkgs; [
      (if stdenv.isDarwin then ghostty-bin else ghostty)
  ];

  xdg.configFile."ghostty/config".source = ../../../../dotfiles/.config/ghostty/config;
}