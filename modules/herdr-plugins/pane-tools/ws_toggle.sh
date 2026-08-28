#!/usr/bin/env bash
# Toggle to the previously focused workspace (recorded by ws_track.sh:
# line 1 is the previous workspace, line 2 the current one).
set -u
state_dir=${HERDR_PLUGIN_STATE_DIR:-$HOME/.local/state/herdr-pane-tools}
prev=$(sed -n 1p "$state_dir/workspace-history" 2>/dev/null)
[[ -z ${prev:-} ]] && exit 0
exec "${HERDR_BIN_PATH:-herdr}" workspace focus "$prev"
