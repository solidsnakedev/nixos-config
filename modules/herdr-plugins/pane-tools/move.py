"""aerospace-style pane move for herdr.

Neighbor in the move direction: swap with it (reorder along the axis).
No neighbor there: re-parent as a split against a perpendicular neighbor,
restructuring the layout (row becomes stack and vice versa), like moving
a window across the container axis in aerospace/i3. Python 3.9 safe.
"""
import json
import os
import subprocess
import sys

DIRECTION = sys.argv[1]
HERDR = os.environ.get("HERDR_BIN_PATH", "herdr")


def api(*args):
    out = subprocess.run([HERDR, *args], capture_output=True, text=True)
    if out.returncode != 0:
        sys.exit(0)
    return json.loads(out.stdout) if out.stdout.strip() else None


pane = os.environ.get("HERDR_PANE_ID")
if not pane:
    pane = api("pane", "current")["result"]["pane"]["pane_id"]


def neighbor(d):
    r = api("pane", "neighbor", "--pane", pane, "--direction", d)
    return r["result"]["neighbor"].get("neighbor_pane_id")


target = neighbor(DIRECTION)
if target:
    api("pane", "swap", "--source-pane", pane, "--target-pane", target)
    sys.exit(0)

perp = ("left", "right") if DIRECTION in ("up", "down") else ("up", "down")
anchor = neighbor(perp[0]) or neighbor(perp[1])
if not anchor:
    sys.exit(0)

tab = os.environ.get("HERDR_TAB_ID")
if not tab:
    tab = api("pane", "get", "--pane", pane)["result"]["pane"]["tab_id"]

# Same-tab re-parenting is a server no-op, so bounce through a temp tab
# (auto-removed once empty) and re-enter with the desired split.
split = "down" if DIRECTION in ("up", "down") else "right"
api("pane", "move", pane, "--new-tab", "--no-focus")
api("pane", "move", pane, "--tab", tab, "--split", split,
    "--target-pane", anchor, "--focus")
if DIRECTION in ("up", "left"):
    api("pane", "swap", "--source-pane", pane, "--target-pane", anchor)
