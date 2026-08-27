"""Shared helpers for reading/writing specs.csv at the repo root.

Each collector (accuracy, PnR, ...) owns a specific set of columns and
merges its results into whatever rows already exist, keyed by
(n16, n8, n4), rather than overwriting the whole file - so collectors
can run in any order without clobbering each other's columns.
"""
import csv
import os

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SPECS_CSV = os.path.join(REPO_ROOT, "specs.csv")


def load_rows():
    """Returns {(n16, n8, n4): {column: value, ...}}, or {} if specs.csv doesn't exist yet."""
    if not os.path.exists(SPECS_CSV):
        return {}
    with open(SPECS_CSV, newline="") as f:
        return {
            (int(row["n16"]), int(row["n8"]), int(row["n4"])): row
            for row in csv.DictReader(f)
        }


def write_rows(rows):
    """Writes {(n16, n8, n4): {column: value, ...}} back to specs.csv, sorted by key."""
    fieldnames = ["n16", "n8", "n4"]
    for row in rows.values():
        for field in row:
            if field not in fieldnames:
                fieldnames.append(field)

    with open(SPECS_CSV, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, restval="")
        writer.writeheader()
        for key in sorted(rows):
            writer.writerow(rows[key])
