{...}: {
  # Starship configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      directory = {
        style = "bold lavender";
      };
    };
  };

  # Enable catppuccin theming for starship.
  catppuccin.starship.enable = true;
}
