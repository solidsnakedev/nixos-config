{ ... }:
{
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
      # Keybinding v2 syntax (herdr >= 0.6.0, flake pins v0.7.3). Bare keys
      # like "m" are DIRECT global bindings in v2 and would steal typing;
      # prefix-mode actions must be written as "prefix+...".
      # Same prefix as tmux.
      prefix = "ctrl+b"

      # tmux: bind | split-window -h / bind - split-window -v
      split_vertical = "prefix+|"
      split_horizontal = "prefix+minus"

      # tmux: bind m resize-pane -Z (maximize/minimize pane)
      zoom = "prefix+m"

      # tmux: vim-tmux-navigator ctrl+h/j/k/l pane movement, same chords here.
      # Direct ctrl bindings steal backspace (ctrl+h), newline (ctrl+j), and
      # clear (ctrl+l) from pane apps, exactly like the tmux plugin does.
      # Pane resizing stays on herdr's resize mode: prefix, then "r".
      focus_pane_left = ["prefix+h", "ctrl+h"]
      focus_pane_down = ["prefix+j", "ctrl+j"]
      focus_pane_up = ["prefix+k", "ctrl+k"]
      focus_pane_right = ["prefix+l", "ctrl+l"]

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
      navigate_pane_up = "ctrl+k"
      navigate_pane_down = "ctrl+j"

      [ui]
      # tmux creates windows immediately without prompting for a name.
      prompt_new_tab_name = false
    '';
  };
}
