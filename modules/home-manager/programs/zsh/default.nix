{
  config,
  lib,
  pkgs,
  dotfilesDir,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
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

    history = {
      share = true; # SHARE_HISTORY: sync history live across all tabs/tmux panes
      extended = true; # EXTENDED_HISTORY: store timestamp + duration per entry
      ignoreDups = true; # HIST_IGNORE_DUPS: drop consecutive duplicate commands
      ignoreAllDups = true; # HIST_IGNORE_ALL_DUPS: remove older dup when a new one is added
      ignoreSpace = true; # HIST_IGNORE_SPACE: skip commands starting with a space
      expireDuplicatesFirst = true; # HIST_EXPIRE_DUPS_FIRST: trim dups first when full
      saveNoDups = true; # HIST_SAVE_NO_DUPS: never write dups to the history file
      findNoDups = true; # HIST_FIND_NO_DUPS: skip dups when searching history
      size = 10000000;
      save = 10000000;
    };

    initContent = ''
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-autopair.src}/zsh-autopair.plugin.zsh
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

      # bindings
      bindkey -e
      bindkey '^H' backward-delete-word
      bindkey '^ ' autosuggest-accept

      # open commands in $EDITOR with C-e
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^e" edit-command-line

      export DOTFILES="$HOME/.dotfiles"
      export WORKSPACE="$HOME/workspace"

      # Other opts
      setopt NO_BG_NICE
      setopt NO_HUP
      setopt NO_BEEP
      setopt LOCAL_OPTIONS
      setopt LOCAL_TRAPS
      setopt PROMPT_SUBST
      setopt CORRECT
      setopt COMPLETE_IN_WORD

      # History hygiene (complements programs.zsh.history)
      setopt HIST_REDUCE_BLANKS   # collapse superfluous whitespace before saving
      setopt HIST_VERIFY          # show expanded !history before running it
      setopt HIST_FCNTL_LOCK      # use fcntl locking, safer with shared history across tmux

      export CLICOLOR=true

      fpath=(${config.xdg.configHome}/zsh/functions(-/FN) $fpath)
      # functions must be autoloaded, do it in a function to isolate
      function {
        local pfunction_glob='^([_.]*|prompt_*_setup|README*|*~)(-.N:t)'

        local pfunction
        # Extended globbing is needed for listing autoloadable function directories.
        setopt LOCAL_OPTIONS EXTENDED_GLOB

        for pfunction in ${config.xdg.configHome}/zsh/functions/$~pfunction_glob; do
          autoload -Uz "$pfunction"
        done
      }

      # Load Global Alias config
      if [ -f $HOME/.aliasrc ]; then
        source $HOME/.aliasrc
      fi

      # Load Custom Zsh config, temporary stuff that I don't want to commit goes here
      if [ -f $HOME/.zshrc.custom ]; then
        source $HOME/.zshrc.custom
      fi
    '';
  };



  xdg.configFile = {
    "zsh" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/zsh";
      recursive = true;
    };
  };
}
