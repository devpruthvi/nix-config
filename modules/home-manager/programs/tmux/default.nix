{pkgs, ...}: {
  # Tmux terminal multiplexer configuration
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 10;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = false;
    terminal = "screen-256color";
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

      # Apply Tc
      set -ga terminal-overrides ",xterm-256color:RGB:smcup@:rmcup@"

      # Enable focus-events
      set -g focus-events on

      # Set default escape-time
      set-option -sg escape-time 10

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
    '';
  };

  # Enable catppuccin theming for tmux.
  catppuccin = {
    tmux = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_flavor "macchiato"
        set -g @catppuccin_status_background "none"

        set -g @catppuccin_window_current_number_color "#{@thm_peach}"
        set -g @catppuccin_window_current_text " #W"
        set -g @catppuccin_window_current_text_color "#{@thm_bg}"
        set -g @catppuccin_window_number_color "#{@thm_blue}"
        set -g @catppuccin_window_text " #W"
        set -g @catppuccin_window_text_color "#{@thm_surface_0}"
      '';
    };
  };
}
