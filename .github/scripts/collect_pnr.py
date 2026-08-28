#!/usr/bin/env python3
"""Collects isolated place-and-route metrics (Mul LUTs, Isolated Fmax) for
the documented N16/N8/N4 configurations by running `make -C HW pnr` and
parsing NextPNR's --report JSON, merging the results into specs.csv at
the repo root (see specs_csv.py).

NextPNR's own exit code is not a valid success signal here: HW/Makefile
deliberately sets an unreachable --freq target to force optimization,
so even a normal, successful run exits non-zero. Success is judged
purely by whether the report file exists and parses.

Any leftover report file is removed right before every PnR run, so a run
that fails to produce a fresh one on a later config can never be mistaken
for success by silently picking up a stale report from an earlier config.
"""
import json
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
import specs_csv  # noqa: E402

HW_DIR = os.path.join(specs_csv.REPO_ROOT, "HW")
REPORT_FILE = os.path.join(HW_DIR, "synth", "report.json")


def run_pnr(n16, n8, n4):
    if os.path.exists(REPORT_FILE):
        os.remove(REPORT_FILE)
    subprocess.run(
        ["make", "-C", HW_DIR, "clean", "pnr", f"N16={n16}", f"N8={n8}", f"N4={n4}"],
        check=False,
    )

    if not os.path.exists(REPORT_FILE):
        raise RuntimeError(
            f"NextPNR report not found for N16={n16} N8={n8} N4={n4} "
            "- PnR likely failed to route at all (not just missed the target frequency)."
        )

    with open(REPORT_FILE) as f:
        report = json.load(f)

    luts = report["utilization"]["ICESTORM_LC"]["used"]
    (fmax_entry,) = report["fmax"].values()
    return luts, fmax_entry["achieved"]


def main():
    rows = specs_csv.load_rows()

    for n16, n8, n4 in specs_csv.CONFIGS:
        luts, fmax_mhz = run_pnr(n16, n8, n4)
        row = rows.setdefault((n16, n8, n4), {"n16": n16, "n8": n8, "n4": n4})
        row["mul_luts"] = luts
        row["isolated_fmax_mhz"] = fmax_mhz

    specs_csv.write_rows(rows)
    print(f"Wrote {len(rows)} rows to {specs_csv.SPECS_CSV}")


if __name__ == "__main__":
    main()
