"""Toggle to the previously focused workspace (recorded by ws_track.py)."""
import json
import os
import sys

herdr = os.environ.get("HERDR_BIN_PATH", "herdr")
state_dir = os.environ.get("HERDR_PLUGIN_STATE_DIR") or os.path.expanduser(
    "~/.local/state/herdr-pane-tools"
)
path = os.path.join(state_dir, "workspace-history.json")

try:
    with open(path) as f:
        prev = json.load(f).get("previous")
except Exception:
    prev = None
if not prev:
    sys.exit(0)

os.execvp(herdr, [herdr, "workspace", "focus", prev])
