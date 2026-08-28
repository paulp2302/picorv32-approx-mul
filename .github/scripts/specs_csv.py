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

# The configurations shown in the specs table. Shared by every
# collector so they all sweep the exact same set.
CONFIGS = [
    (0, 0, 0),
    (16, 0, 0),
    (16, 8, 0),
    (16, 8, 4),
]

# Canonical column order grouped by logical connection. Any column not
# listed here (e.g. from a future collector) is still written, just
# appended after these in whatever order it's first seen.
FIELDNAMES = [
    "n16",
    "n8",
    "n4",
    "median_relative_error",
    "max_relative_error",
    "mul_luts",
    "isolated_fmax_mhz",
    "total_luts",
    "system_fmax_mhz",
]

# Defines how to cast each column back to a real type on load from
# csv.DictReader. Columns not listed here are left as whatever 
# csv.DictReader returns.
COLUMN_TYPES = {
    "n16": int,
    "n8": int,
    "n4": int,
    "median_relative_error": float,
    "max_relative_error": float,
    "mul_luts": int,
    "isolated_fmax_mhz": float,
    "total_luts": int,
    "system_fmax_mhz": float,
}


def load_rows():
    """Returns {(n16, n8, n4): {column: value, ...}}, or {} if specs.csv doesn't exist yet."""
    if not os.path.exists(SPECS_CSV):
        return {}
    rows = {}
    with open(SPECS_CSV, newline="") as f:
        for row in csv.DictReader(f):
            for col, cast in COLUMN_TYPES.items():
                if row.get(col):
                    row[col] = cast(row[col])
            rows[(row["n16"], row["n8"], row["n4"])] = row
    return rows


def write_rows(rows):
    """Writes {(n16, n8, n4): {column: value, ...}} back to specs.csv, sorted by key."""
    fieldnames = list(FIELDNAMES)
    for row in rows.values():
        for field in row:
            if field not in fieldnames:
                fieldnames.append(field)

    with open(SPECS_CSV, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, restval="")
        writer.writeheader()
        for key in sorted(rows):
            writer.writerow(rows[key])
