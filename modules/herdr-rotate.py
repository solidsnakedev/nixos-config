"""Rotate herdr panes in the current tab, like tmux rotate-window.

Usage: herdr-rotate [-r]   (-r rotates the other way)
"""
import json
import subprocess
import sys


def api(*args):
    out = subprocess.run(["herdr", *args], capture_output=True, text=True)
    if out.returncode != 0:
        sys.exit(f"herdr {' '.join(args)} failed: {out.stderr.strip()}")
    return json.loads(out.stdout)


layout = api("pane", "layout", "--current")["result"]["layout"]
panes = sorted(layout["panes"], key=lambda p: (p["rect"]["y"], p["rect"]["x"]))
ids = [p["pane_id"] for p in panes]
if len(ids) < 2:
    sys.exit(0)

order = range(1, len(ids)) if "-r" not in sys.argv else range(len(ids) - 1, 0, -1)
for i in order:
    api("pane", "swap", "--source-pane", ids[0], "--target-pane", ids[i])
