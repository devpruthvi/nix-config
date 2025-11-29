{pkgs, config, ...}: {
  # Tmux terminal multiplexer configuration
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 10;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = false;
    terminal = "tmux-256color";
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
    ];

    extraConfig = ''
      # Bind Arrow keys to resize the window
      bind -n S-Down resize-pane -D 8
      bind -n S-Up resize-pane -U 8
      bind -n S-Left resize-pane -L 8
      bind -n S-Right resize-pane -R 8

      # Rename window with prefix + r
      bind r command-prompt -I "#W" "rename-window '%%'"

      # Reload tmux config by pressing prefix + R
      bind R source-file ~/.config/tmux/tmux.conf \; display "TMUX Conf Reloaded"

      # Clear screen with prefix + l
      bind C-l send-keys 'C-l'

      # Open a project in a separate window
      bind-key -n C-f run-shell "tmux new-window -t 10 -n project-selector cd-to-project"

      # Apply Tc and italics
      set -ga terminal-overrides ",xterm-256color:RGB:smcup@:rmcup@"
      set -as terminal-overrides ',*:sitm=\E[3m'

      # Enable focus-events
      set -g focus-events on

      # Set default escape-time
      set-option -sg escape-time 10

      # Custom Status Bar with Italics
      # Replaces Stylix's default which forces noitalics
      set-option -g status "on"
      set-option -g status-justify "left"
      set-option -g status-style "bg=#${config.lib.stylix.colors.base00},fg=#${config.lib.stylix.colors.base05}"
      set-option -g status-left "#[fg=#${config.lib.stylix.colors.base0D},bg=#${config.lib.stylix.colors.base02},bold,italic] #S #[fg=#${config.lib.stylix.colors.base02},bg=#${config.lib.stylix.colors.base00},nobold,noitalics,nounderscore]"
      set-option -g status-left-length "80"
      set-option -g status-right "#[fg=#${config.lib.stylix.colors.base02},bg=#${config.lib.stylix.colors.base00},nobold,nounderscore,noitalics]#[fg=#${config.lib.stylix.colors.base05},bg=#${config.lib.stylix.colors.base02},italic] %Y-%m-%d  %H:%M #[fg=#${config.lib.stylix.colors.base0D},bg=#${config.lib.stylix.colors.base02},nobold,noitalics,nounderscore]#[fg=#${config.lib.stylix.colors.base00},bg=#${config.lib.stylix.colors.base0D},bold,italic] #h "
      set-option -g status-right-length "80"
      
      set-window-option -g window-status-current-format "#[fg=#${config.lib.stylix.colors.base00},bg=#${config.lib.stylix.colors.base0A},nobold,noitalics,nounderscore]#[fg=#${config.lib.stylix.colors.base02},bg=#${config.lib.stylix.colors.base0A},bold,italic] #I  #W#{?window_zoomed_flag,*Z,} #[fg=#${config.lib.stylix.colors.base0A},bg=#${config.lib.stylix.colors.base00},nobold,noitalics,nounderscore]"
      set-window-option -g window-status-format "#[fg=#${config.lib.stylix.colors.base00},bg=#${config.lib.stylix.colors.base02},noitalics]#[fg=#${config.lib.stylix.colors.base05},bg=#${config.lib.stylix.colors.base02},italic] #I  #W#{?window_zoomed_flag,*Z,} #[fg=#${config.lib.stylix.colors.base02},bg=#${config.lib.stylix.colors.base00},noitalics]"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
    '';
  };

  # Enable stylix theming for tmux.
  stylix.targets.tmux.enable = true;
}
