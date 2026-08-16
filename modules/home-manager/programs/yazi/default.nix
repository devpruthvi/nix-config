{...}: {
  # Install yazi via home-manager module
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  # Enable stylix theming for yazi.
  stylix.targets.yazi.enable = true;
}
