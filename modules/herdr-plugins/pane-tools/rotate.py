"""Rotate herdr panes in the current tab, like tmux rotate-window.

Runs as a herdr plugin action (uses HERDR_PANE_ID/HERDR_BIN_PATH when
invoked by a keybinding) or standalone from a shell pane. -r reverses.
"""
import json
import os
import subprocess
import sys

HERDR = os.environ.get("HERDR_BIN_PATH", "herdr")
PANE = os.environ.get("HERDR_PANE_ID")


def api(*args):
    out = subprocess.run([HERDR, *args], capture_output=True, text=True)
    if out.returncode != 0:
        sys.exit(f"herdr {' '.join(args)} failed: {out.stderr.strip()}")
    return json.loads(out.stdout)


pane_ref = ["--pane", PANE] if PANE else ["--current"]
layout = api("pane", "layout", *pane_ref)["result"]["layout"]
panes = sorted(layout["panes"], key=lambda p: (p["rect"]["y"], p["rect"]["x"]))
ids = [p["pane_id"] for p in panes]
if len(ids) < 2:
    sys.exit(0)

order = range(1, len(ids)) if "-r" not in sys.argv else range(len(ids) - 1, 0, -1)
for i in order:
    api("pane", "swap", "--source-pane", ids[0], "--target-pane", ids[i])
