#!/usr/bin/env python3
"""Collects accuracy metrics (median/max relative error vs. the exact
result) for the documented N16/N8/N4 configurations and merges the
results into specs.csv at the repo root (see specs_csv.py).

This is meant to be run manually (see .github/workflows/specs-table.yml),
not on every push - so it always recomputes its own columns for every
row rather than skipping ones that already have data. That way, changing
the underlying approximate multiplier design and re-running this gives
you fresh numbers without having to clear specs.csv by hand first.

Uses a fixed random seed so every config is compared against the exact
same set of input pairs (reproducible, and not confounded by different
random draws landing more or less favorably for different configs).
"""
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import specs_csv  # noqa: E402

REF_DIR = os.path.join(specs_csv.REPO_ROOT, "HW", "REF")
sys.path.insert(0, REF_DIR)
from exactVSapproxMul import exactVSapproxMul  # noqa: E402

TEST_VEC_SIZE = 10000
WIDTH = 16
SEED = 0


def main():
    rows = specs_csv.load_rows()

    for n16, n8, n4 in specs_csv.CONFIGS:
        _avg_error, median_error, max_error = exactVSapproxMul(
            TEST_VEC_SIZE, WIDTH, n16, n8, n4, plot_scatter=False, seed=SEED
        )
        row = rows.setdefault((n16, n8, n4), {"n16": n16, "n8": n8, "n4": n4})
        row["median_relative_error"] = median_error
        row["max_relative_error"] = max_error

    specs_csv.write_rows(rows)
    print(f"Wrote {len(rows)} rows to {specs_csv.SPECS_CSV}")


if __name__ == "__main__":
    main()
