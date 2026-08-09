{
  config,
  pkgs,
  lib,
  dotfilesDir,
  ...
}: let
  javaRuntimes = {
    "JavaSE-17" = pkgs.jdk17;
    "JavaSE-21" = pkgs.jdk21;
  };
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    sideloadInitLua = true;

    extraPackages =
      (with pkgs; [
        # nvim-treesitter `main` branch compiles parsers via the tree-sitter CLI
        tree-sitter
        # snacks.picker grep/files
        ripgrep
        fd
        lua-language-server
        gopls
        stylua
        clang-tools
        prettierd
        black
        isort
      ])
      ++ (lib.attrValues javaRuntimes);
  };

  # source lua config from dotfiles
  xdg.configFile =
    {
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/nvim";
        recursive = true;
      };

      "lsp/java/lombok.jar".source = "${pkgs.lombok}/share/java/lombok.jar";
    }
    // (lib.mapAttrs' (name: jdk:
      lib.nameValuePair "lsp/java/runtimes/${name}" {source = "${jdk.home}";})
    javaRuntimes);
}
