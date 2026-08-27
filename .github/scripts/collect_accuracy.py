#!/usr/bin/env python3
"""Collects accuracy metrics (median/max relative error vs. the exact
result) for the documented N16/N8/N4 configurations and overwrites
specs.csv at the repo root with the results.

This is meant to be run manually (see .github/workflows/specs-table.yml),
not on every push - so it always recomputes and overwrites every row
rather than skipping ones that already have data. That way, changing the
underlying approximate multiplier design and re-running this gives you
fresh numbers without having to clear specs.csv by hand first.

Future data (e.g. place-and-route LUT/Fmax numbers) should be added by a
separate collector that merges its own columns into existing rows rather
than overwriting this file outright, since that data is much more
expensive to (re)compute than this accuracy pass.
"""
import csv
import os
import sys

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
REF_DIR = os.path.join(REPO_ROOT, "HW", "REF")
SPECS_CSV = os.path.join(REPO_ROOT, "specs.csv")

sys.path.insert(0, REF_DIR)
from exactVSapproxMul import exactVSapproxMul  # noqa: E402

# The configurations shown in the README results table.
CONFIGS = [
    (0, 0, 0),
    (16, 0, 0),
    (16, 8, 0),
    (16, 8, 4),
]

TEST_VEC_SIZE = 10000
WIDTH = 16

FIELDNAMES = ["n16", "n8", "n4", "median_relative_error", "max_relative_error"]


def main():
    rows = []
    for n16, n8, n4 in CONFIGS:
        _avg_error, median_error, max_error = exactVSapproxMul(
            TEST_VEC_SIZE, WIDTH, n16, n8, n4, plot_scatter=False
        )
        rows.append({
            "n16": n16,
            "n8": n8,
            "n4": n4,
            "median_relative_error": median_error,
            "max_relative_error": max_error,
        })

    with open(SPECS_CSV, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDNAMES)
        writer.writeheader()
        writer.writerows(rows)

    print(f"Wrote {len(rows)} rows to {SPECS_CSV}")


if __name__ == "__main__":
    main()
