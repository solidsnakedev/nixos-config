{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    shell = "${pkgs.fish}/bin/fish";
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
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

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
      
      # Rotate panes clockwise and keep focus on the pane
      bind r rotate-window -U \; select-pane -t -

      # Rotate panes counter-clockwise and keep focus on the pane
      bind R rotate-window -D \; select-pane -t +

      # Renumber windows when adding a new one
      set -g renumber-windows on
    '';
  };
}

