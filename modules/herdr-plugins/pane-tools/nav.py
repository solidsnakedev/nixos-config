"""vim-navigator for herdr: ctrl+hjkl bound via keys.command.

If the focused pane runs (n)vim, forward the chord into it so nvim moves
between its own windows (nvim calls back to `herdr pane focus` at the
edge, see init.lua). Any other pane focuses the herdr neighbor directly.
Python 3.9 safe.
"""
import json
import os
import subprocess
import sys

DIRECTION = sys.argv[1]
KEY = {"left": "ctrl+h", "down": "ctrl+j", "up": "ctrl+k", "right": "ctrl+l"}[DIRECTION]
HERDR = os.environ.get("HERDR_BIN_PATH", "herdr")


def api(*args):
    out = subprocess.run([HERDR, *args], capture_output=True, text=True)
    if out.returncode != 0:
        sys.exit(0)
    return json.loads(out.stdout) if out.stdout.strip() else None


pane = os.environ.get("HERDR_PANE_ID")
if not pane:
    pane = api("pane", "current")["result"]["pane"]["pane_id"]

info = api("pane", "process-info", "--pane", pane)["result"]["process_info"]
procs = info.get("foreground_processes") or []
in_vim = any(
    os.path.basename(p.get("argv0") or "") in ("nvim", "vim") for p in procs
)

if in_vim:
    api("pane", "send-keys", pane, KEY)
else:
    api("pane", "focus", "--direction", DIRECTION, "--pane", pane)
