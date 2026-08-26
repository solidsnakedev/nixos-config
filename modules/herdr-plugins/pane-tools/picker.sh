#!/usr/bin/env bash
# Runs inside a herdr overlay pane: fuzzy-pick a workspace, focus it, exit.
set -euo pipefail
HERDR="${HERDR_BIN_PATH:-herdr}"
FZF="$(command -v fzf || echo "$HOME/.nix-profile/bin/fzf")"
PY="$(command -v python3 || echo /usr/bin/python3)"

sel="$("$HERDR" workspace list | "$PY" -c '
import json, sys
ws = json.load(sys.stdin)["result"]["workspaces"]
for w in ws:
    mark = "*" if w.get("focused") else " "
    print("%2d %s %s\t%s" % (w["number"], mark, w["label"], w["workspace_id"]))
' | "$FZF" --reverse --prompt='workspace> ' --with-nth=1 --delimiter='\t')" || exit 0

exec "$HERDR" workspace focus "${sel##*$'\t'}"
