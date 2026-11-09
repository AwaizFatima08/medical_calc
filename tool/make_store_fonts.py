"""Builds Roboto with the few symbols it lacks (₂ ₃ ⁹ → ↔ ∛) merged in from DejaVu Sans.

The Flutter test engine has no font fallback, so test_store/ screenshots need them inside 'Roboto'.
Phones have fallback fonts, so the app itself needs nothing.
Run:  python3 tool/make_store_fonts.py <out_dir>     (needs fontTools, Debian fonts-dejavu)
"""
import os
import pathlib
import sys

from fontTools import subset
from fontTools.merge import Merger
from fontTools.ttLib import TTFont
from fontTools.ttLib.scaleUpem import scale_upem

ROBOTO = pathlib.Path(os.environ["FLUTTER_ROOT"]) / "bin/cache/artifacts/material_fonts"
DEJAVU = pathlib.Path("/usr/share/fonts/truetype/dejavu")
OUT = pathlib.Path(sys.argv[1])
EXTRA = [0x2079, 0x2082, 0x2083, 0x2192, 0x2194, 0x221B]


def clean(font, path):
    """Drops tables the merger can't combine."""
    for tag in ["MATH", "STAT", "fvar", "gvar", "avar", "HVAR", "meta", "DSIG", "vhea", "vmtx", "kern"]:
        if tag in font:
            del font[tag]
    font.save(path)
    return str(path)


OUT.mkdir(parents=True, exist_ok=True)
for weight, dejavu in [("Regular", "DejaVuSans"), ("Medium", "DejaVuSans"), ("Bold", "DejaVuSans-Bold")]:
    extra = TTFont(DEJAVU / f"{dejavu}.ttf")
    sub = subset.Subsetter()
    sub.populate(unicodes=EXTRA)
    sub.subset(extra)
    scale_upem(extra, 2048)  # same units as Roboto, or the merge fails
    parts = [clean(TTFont(ROBOTO / f"Roboto-{weight}.ttf"), OUT / f"part-roboto-{weight}.ttf"),
             clean(extra, OUT / f"part-extra-{weight}.ttf")]
    merged = Merger().merge(parts)
    merged["name"] = TTFont(ROBOTO / f"Roboto-{weight}.ttf")["name"]
    merged.save(OUT / f"Roboto-{weight}.ttf")
    for p in parts:
        os.remove(p)
    print("wrote", OUT / f"Roboto-{weight}.ttf")
