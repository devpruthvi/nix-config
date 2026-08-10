{
  pkgs,
  ...
}: {
  # Zsh configuration
  programs.zsh.enable = true;

  # Fonts configuration
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    (pkgs.callPackage ./iosvmata.nix {})
  ];

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim
    home-manager
    git
    libxcvt
    arandr
  ];
}
