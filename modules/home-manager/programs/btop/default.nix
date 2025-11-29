{...}: {
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
  };

  stylix.targets.btop.enable = true;
}
