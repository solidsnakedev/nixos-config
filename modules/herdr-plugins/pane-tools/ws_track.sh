#!/usr/bin/env bash
# workspace.focused event handler: record focus history for the
# last-workspace toggle. HERDR_WORKSPACE_ID in the event env is the newly
# focused workspace (verified), so this needs no herdr calls. State is two
# lines (previous, current) written atomically; a mkdir lock keeps rapid
# concurrent events from interleaving read-then-write (macOS has no flock).
set -u
new=${HERDR_WORKSPACE_ID:-}
[[ -z $new ]] && exit 0
state_dir=${HERDR_PLUGIN_STATE_DIR:-$HOME/.local/state/herdr-pane-tools}
mkdir -p "$state_dir"
f=$state_dir/workspace-history
lock=$state_dir/workspace-history.lock

# Steal locks older than 5s (a handler killed mid-write); otherwise skip
# on contention, the next focus event will record the fresh state anyway.
if ! mkdir "$lock" 2>/dev/null; then
  if [[ -n $(find "$lock" -maxdepth 0 -mmin +0.08 2>/dev/null) ]]; then
    rmdir "$lock" 2>/dev/null
    mkdir "$lock" 2>/dev/null || exit 0
  else
    exit 0
  fi
fi
trap 'rmdir "$lock" 2>/dev/null' EXIT

cur=""
[[ -f $f ]] && cur=$(sed -n 2p "$f")
if [[ $cur != "$new" ]]; then
  printf '%s\n%s\n' "$cur" "$new" > "$f.tmp" && mv "$f.tmp" "$f"
fi
