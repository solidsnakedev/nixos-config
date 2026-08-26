"""Event handler for workspace.focused: record workspace focus history.

Keeps {"previous": ..., "current": ...} in the plugin state dir so the
last-workspace toggle knows where to jump back to. Python 3.9 safe.
"""
import json
import os
import subprocess
import sys

herdr = os.environ.get("HERDR_BIN_PATH", "herdr")
state_dir = os.environ.get("HERDR_PLUGIN_STATE_DIR") or os.path.expanduser(
    "~/.local/state/herdr-pane-tools"
)
os.makedirs(state_dir, exist_ok=True)
path = os.path.join(state_dir, "workspace-history.json")

out = subprocess.run([herdr, "workspace", "list"], capture_output=True, text=True)
if out.returncode != 0:
    sys.exit(0)
ws = json.loads(out.stdout)["result"]["workspaces"]
new = next((w["workspace_id"] for w in ws if w.get("focused")), None)
if not new:
    sys.exit(0)

try:
    with open(path) as f:
        st = json.load(f)
except Exception:
    st = {}

if st.get("current") != new:
    st = {"previous": st.get("current"), "current": new}
    with open(path, "w") as f:
        json.dump(st, f)
