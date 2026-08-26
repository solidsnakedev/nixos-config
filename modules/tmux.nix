{ pkgs, ... }:
let
  # herdr look — Catppuccin Mocha palette (herdr's default theme).
  # Values mirror herdr's Palette::catppuccin() so the tmux chrome matches
  # the agent multiplexer's flat tab-cell styling.
  bg       = "#181825"; # panel_bg — status bar background / active-tab text
  surface0 = "#313244"; # inactive-tab background
  surface1 = "#45475a"; # copy-mode selection
  overlay0 = "#6c7086"; # muted text
  overlay1 = "#7f849c"; # dim text — inactive-tab foreground
  text     = "#cdd6f4"; # foreground
  accent   = "#89b4fa"; # blue — active highlight (active tab / pane border)
in
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    shell = "${pkgs.zsh}/bin/zsh";
    # customPaneNavigationAndResize = true;
    plugins = with pkgs.tmuxPlugins ; [
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

      # aerospace-style direct swap: ctrl+shift+hjkl moves the pane the way
      # alt+shift+hjkl moves a window (mirrors herdr's swap chords). Needs
      # extended keys so ctrl+shift is distinguishable from plain ctrl.
      set -s extended-keys on
      set -as terminal-features 'alacritty*:extkeys'
      bind -n C-S-h swap-pane -t '{left-of}'
      bind -n C-S-j swap-pane -t '{down-of}'
      bind -n C-S-k swap-pane -t '{up-of}'
      bind -n C-S-l swap-pane -t '{right-of}'

      # Rotate panes clockwise and keep focus on the pane
      bind r rotate-window -U \; select-pane -t -

      # Rotate panes counter-clockwise and keep focus on the pane
      bind R rotate-window -D \; select-pane -t +

      # Renumber windows when adding a new one
      set -g renumber-windows on

      # ── herdr-style theme (Catppuccin Mocha, flat tab cells) ───────────────
      # herdr's tab bar lives at the top; mirror that here.
      set -g status-position top
      set -g status-justify left
      set -g status-style "bg=${bg},fg=${text}"

      # Left: session name as an accent "brand" segment, like herdr's sidebar.
      set -g status-left-length 40
      set -g status-left "#[fg=${bg},bg=${accent},bold] #S #[fg=${bg},bg=${bg}] "

      # Right: dim host + clock, matching herdr's muted chrome.
      set -g status-right-length 60
      set -g status-right "#[fg=${overlay0}]#H #[fg=${overlay1}]%H:%M "

      # Windows == tabs: flat colored cells with a 1-column gap. No powerline.
      set -g window-status-separator " "
      set -g window-status-format "#[fg=${overlay1},bg=${surface0}] #I #W "
      set -g window-status-current-format "#[fg=${bg},bg=${accent},bold] #I #W "

      # Pane borders: accent for the active pane (herdr's accent dividers).
      set -g pane-border-style "fg=${surface0}"
      set -g pane-active-border-style "fg=${accent}"

      # Command prompt / messages.
      set -g message-style "bg=${accent},fg=${bg}"
      set -g message-command-style "bg=${surface1},fg=${text}"

      # Copy-mode selection and clock.
      set -g mode-style "bg=${surface1},fg=${text}"
      set -g clock-mode-colour "${accent}"
    '';
  };
}
