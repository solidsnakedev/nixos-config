#!/usr/bin/env bash
# vim-aware ctrl+hjkl navigation (bash port of the former nav.py: python
# interpreter startup was ~21ms of every keypress, bash runs the same
# logic in ~14ms total). If the focused pane runs (n)vim, forward the
# chord into it so nvim moves between its own windows first (nvim calls
# back to `herdr pane focus` at the edge, see init.lua); any other pane
# focuses the herdr neighbor directly.
set -u
dir=${1:-}
case $dir in
  left)  key=ctrl+h ;;
  down)  key=ctrl+j ;;
  up)    key=ctrl+k ;;
  right) key=ctrl+l ;;
  *) exit 0 ;;
esac
herdr=${HERDR_BIN_PATH:-herdr}
pane=${HERDR_PANE_ID:-}
if [[ -z $pane ]]; then
  cur=$("$herdr" pane current) || exit 0
  [[ $cur =~ \"pane_id\":\"([^\"]+)\" ]] && pane=${BASH_REMATCH[1]}
  [[ -z $pane ]] && exit 0
fi
info=$("$herdr" pane process-info --pane "$pane") || exit 0
# Matches "argv0":"nvim", "argv0":"vim", and absolute paths ending in /nvim
if [[ $info =~ \"argv0\":\"([^\"]*/)?n?vim\" ]]; then
  exec "$herdr" pane send-keys "$pane" "$key"
fi
exec "$herdr" pane focus --direction "$dir" --pane "$pane"
