{
  config,
  pkgs,
  dotfilesDir,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    sideloadInitLua = true;

    extraPackages = with pkgs; [
      # nvim-treesitter `main` branch compiles parsers via the tree-sitter CLI
      tree-sitter
      # snacks.picker grep/files
      ripgrep
      fd
    ];
  };

  # source lua config from dotfiles
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/nvim";
      recursive = true;
    };
  };
}
