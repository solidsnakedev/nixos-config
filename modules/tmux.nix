{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    # customPaneNavigationAndResize = true;
    plugins = with pkgs.tmuxPlugins ; [
      # {
      #   plugin = dracula;
      #   extraConfig = ''
      #     set -g @dracula-plugins "cpu-usage ram-usage time"
      #     set -g @dracula-show-battery false
      #     set -g @dracula-show-powerline true
      #     set -g @dracula-refresh-rate 10
      #     set -g @dracula-show-flags true
      #   '';
      # }
      {
        plugin = catppuccin;
        extraConfig = '' 
        '';
      }
      vim-tmux-navigator
    ];
    extraConfig = ''
      #Configure True Colors
      set -g default-terminal "screen-256color"

      #Add keybind for maximizing and minimizing tmux pane
      bind -r m resize-pane -Z

      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # resizing tmux panes
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5

      # Renumber windows when adding a new one
      set -g renumber-windows on
    '';
  };
}
