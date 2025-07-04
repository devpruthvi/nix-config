{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;

    extraPackages = with pkgs; [
    ];
  };

  # # source lua config from dotfiles
  # xdg.configFile = {
  #   "nvim" = {
  #     source = config.lib.file.mkOutOfStoreSymlink ../../../../dotfiles/.config/nvim;
  #     recursive = true;
  #   };
  # };
}
