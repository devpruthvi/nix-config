{...}: {
  # Install bat via home-manager module
  programs.bat = {
    enable = true;
  };

  # Enable catppuccin theming for bat.
  # Enable stylix theming for bat.
  stylix.targets.bat.enable = true;
}
