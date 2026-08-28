{ pkgs, ... }:
{
  # tmux: bind r rotate-window. herdr has no rotate action or command
  # keybindings, so this ships as a CLI (`herdr-rotate`, -r for the other
  # direction) driving `herdr pane swap` over the current tab.
  home.packages = [
    (pkgs.writers.writePython3Bin "herdr-rotate" { flakeIgnore = [ "E501" ]; }
      (builtins.readFile ./herdr-rotate.py))
  ];

  # Mirror of modules/tmux.nix for herdr: same prefix-mode keybindings and
  # the Catppuccin Mocha theme the tmux chrome is modeled on.
  # Apply without restarting via `herdr server reload-config`.
  xdg.configFile."herdr/config.toml" = {
    force = true; # replace the hand-written config.toml from onboarding
    text = ''
      onboarding = false

      [theme]
      # tmux theme mirrors herdr's Palette::catppuccin(); keep them in sync.
      name = "catppuccin"

      [keys]
      # Keybinding v2 syntax (herdr >= 0.8, for resize_pane_*; tracks
      # nixpkgs). Bare keys
      # like "m" are DIRECT global bindings in v2 and would steal typing;
      # prefix-mode actions must be written as "prefix+...".
      # Same prefix as tmux.
      prefix = "ctrl+b"

      # tmux: bind | split-window -h / bind - split-window -v
      split_vertical = "prefix+|"
      split_horizontal = "prefix+minus"

      # tmux: bind m resize-pane -Z, plus tmux's default prefix+z
      zoom = ["prefix+m", "prefix+z"]

      # tmux: prefix+; toggles the last focused pane (tmux default).
      last_pane = "prefix+;"

      # ctrl+h/j/k/l pane movement lives on the vim-aware nav plugin
      # actions below (keys.command), which forward into nvim panes the way
      # vim-tmux-navigator does. The built-in focus actions get no direct
      # chords; navigate mode still has pane focus.
      focus_pane_left = []
      focus_pane_down = []
      focus_pane_up = []
      focus_pane_right = []

      # tmux: bind -r h/j/k/l resize-pane. Direct resize actions exist since
      # herdr 0.8, so prefix+hjkl resizes here too (herdr's resize mode stays
      # on prefix+r as a fallback).
      resize_pane_left = "prefix+h"
      resize_pane_down = "prefix+j"
      resize_pane_up = "prefix+k"
      resize_pane_right = "prefix+l"

      # ctrl+shift+hjkl is the aerospace-style move (pane-tools plugin,
      # keys.command below): reorders along the layout axis, restructures
      # across it. Plain swap stays on herdr's prefix+shift defaults.
      swap_pane_left = "prefix+shift+h"
      swap_pane_down = "prefix+shift+j"
      swap_pane_up = "prefix+shift+k"
      swap_pane_right = "prefix+shift+l"

      # Step through workspaces with hjkl-flavored direct chords: ctrl+alt+h/l
      # moves to the previous/next workspace and back, no prefix or navigate
      # mode needed. (ctrl+alt is free: aerospace uses plain alt, panes use
      # plain ctrl.)
      previous_workspace = "ctrl+alt+h"
      next_workspace = "ctrl+alt+l"

      # Navigate mode (prefix+w): vim-style j/k over the workspace list instead
      # of the default arrow keys. Pane focus inside navigate mode moves to
      # ctrl+j/k to free the plain keys (matches the global ctrl+hjkl chords;
      # navigate-mode bindings conflict-check locally, so j/k can't do both).
      navigate_workspace_up = ["k", "up"]
      navigate_workspace_down = ["j", "down"]
      navigate_pane_left = "ctrl+h"
      navigate_pane_down = "ctrl+j"
      navigate_pane_up = "ctrl+k"
      navigate_pane_right = "ctrl+l"

      # tmux: bind r / R rotate panes, via the pane-tools plugin below.
      # Frees prefix+r and prefix+shift+r by moving herdr's resize mode and
      # config reload to ctrl variants (resize also lives on prefix+hjkl,
      # reload also on `herdr server reload-config`).
      resize_mode = "prefix+ctrl+r"
      reload_config = "prefix+ctrl+shift+r"

      # Plugin source: modules/herdr-plugins/pane-tools, registered once with
      # `herdr plugin link ~/nixos-config/modules/herdr-plugins/pane-tools`.
      [[keys.command]]
      key = "prefix+r"
      type = "plugin_action"
      command = "pane-tools.rotate"
      description = "Rotate panes"

      [[keys.command]]
      key = "prefix+shift+r"
      type = "plugin_action"
      command = "pane-tools.rotate-reverse"
      description = "Rotate panes (reverse)"

      # Fuzzy workspace picker overlay (fzf), one chord instead of
      # prefix+w and arrowing through the list. ctrl+alt matches the
      # workspace chord family (ctrl+alt+h/l).
      [[keys.command]]
      key = "ctrl+alt+w"
      type = "plugin_action"
      command = "pane-tools.pick-workspace"
      description = "Workspace picker"

      # Workspace back-and-forth like aerospace's alt+tab: jumps to the
      # previously focused workspace (history tracked by the plugin's
      # workspace.focused event handler).
      [[keys.command]]
      key = "ctrl+alt+tab"
      type = "plugin_action"
      command = "pane-tools.last-workspace"
      description = "Toggle last workspace"

      # vim-aware pane navigation (vim-tmux-navigator equivalent): forwards
      # the chord into nvim panes, focuses the herdr neighbor otherwise.
      [[keys.command]]
      key = "ctrl+h"
      type = "plugin_action"
      command = "pane-tools.nav-left"
      description = "Navigate left (vim-aware)"

      [[keys.command]]
      key = "ctrl+j"
      type = "plugin_action"
      command = "pane-tools.nav-down"
      description = "Navigate down (vim-aware)"

      [[keys.command]]
      key = "ctrl+k"
      type = "plugin_action"
      command = "pane-tools.nav-up"
      description = "Navigate up (vim-aware)"

      [[keys.command]]
      key = "ctrl+l"
      type = "plugin_action"
      command = "pane-tools.nav-right"
      description = "Navigate right (vim-aware)"

      # aerospace-style pane move: swap along the axis, restructure across
      # it (row to stack and back), mirroring alt+shift+hjkl for windows.
      [[keys.command]]
      key = "ctrl+shift+h"
      type = "plugin_action"
      command = "pane-tools.move-left"
      description = "Move pane left"

      [[keys.command]]
      key = "ctrl+shift+j"
      type = "plugin_action"
      command = "pane-tools.move-down"
      description = "Move pane down"

      [[keys.command]]
      key = "ctrl+shift+k"
      type = "plugin_action"
      command = "pane-tools.move-up"
      description = "Move pane up"

      [[keys.command]]
      key = "ctrl+shift+l"
      type = "plugin_action"
      command = "pane-tools.move-right"
      description = "Move pane right"

      [ui]
      # tmux creates windows immediately without prompting for a name.
      prompt_new_tab_name = false
    '';
  };
}
