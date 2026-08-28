#!/usr/bin/env bash
# Runs inside a herdr overlay pane: fuzzy-pick a workspace, focus it, exit.
# The workspace list JSON is parsed with awk; spawning python for it cost
# a measured 21ms of the picker's open time.
set -euo pipefail
HERDR="${HERDR_BIN_PATH:-herdr}"
FZF="$(command -v fzf || echo "$HOME/.nix-profile/bin/fzf")"

sel="$("$HERDR" workspace list | awk -v RS='},{' '{
  num = ""; lab = ""; id = ""; foc = " ";
  if (match($0, /"number":[0-9]+/))         num = substr($0, RSTART + 9,  RLENGTH - 9);
  if (match($0, /"label":"[^"]*"/))         lab = substr($0, RSTART + 9,  RLENGTH - 10);
  if (match($0, /"workspace_id":"[^"]*"/))  id  = substr($0, RSTART + 16, RLENGTH - 17);
  if ($0 ~ /"focused":true/)                foc = "*";
  if (id != "") printf "%2d %s %s\t%s\n", num, foc, lab, id;
}' | "$FZF" --reverse --prompt='workspace> ' --with-nth=1 --delimiter='\t')" || exit 0

exec "$HERDR" workspace focus "${sel##*$'\t'}"
