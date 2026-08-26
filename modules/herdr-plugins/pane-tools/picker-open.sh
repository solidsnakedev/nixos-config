#!/usr/bin/env bash
# Keybinding action: open the workspace picker overlay on the focused workspace.
exec "${HERDR_BIN_PATH:-herdr}" plugin pane open --plugin pane-tools --entrypoint picker --focus
