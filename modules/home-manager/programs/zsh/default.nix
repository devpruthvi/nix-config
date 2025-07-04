{
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      lg = "lazygit";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      ls = "eza --icons always"; # default view
      ll = "eza -bhl --icons --group-directories-first"; # long list
      la = "eza -abhl --icons --group-directories-first"; # all list
      lt = "eza --tree --level=2 --icons"; # tree
    };

    initContent = ''
      # bindings
      bindkey -e
      bindkey '^H' backward-delete-word

      # open commands in $EDITOR with C-e
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^e" edit-command-line
    '';
  };
}
