#!/usr/bin/env python3
"""Collects full-SoC place-and-route metrics (Total LUTs, System Clock
Fmax) for the documented N16/N8/N4 configurations and merges the results
into specs.csv at the repo root (see specs_csv.py).

Unlike the isolated multiplier PnR (collect_pnr.py), this routes the
whole PicoRV32 SoC with the multiplier integrated, so it needs:
  - HW/synth/custom_mul.v built for the specific config first - the
    isolated PnR path never builds this file, it synthesizes a separate
    benchmark-wrapped design instead
  - a RISC-V cross-compiler (riscv64-unknown-elf-gcc) to build the
    firmware image that gets baked into BRAM at synthesis time; this is
    not part of the OSS CAD Suite and must be installed separately
  - `make clean <target1> <target2>` in one invocation, since the
    picosoc Makefile's icebreaker.json rule reads the firmware hex file
    via $readmemh without declaring it as a Make prerequisite, so the
    firmware must already exist on disk by the time synthesis runs

As with the isolated PnR, NextPNR's own exit code is not a valid success
signal: the Makefile targets --freq 35, well above what this design
achieves, so even a normal run exits non-zero. Success is judged purely
by whether the report file exists and parses.
"""
import json
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
import specs_csv  # noqa: E402

HW_DIR = os.path.join(specs_csv.REPO_ROOT, "HW")
PICOSOC_DIR = os.path.join(specs_csv.REPO_ROOT, "picorv32", "picosoc")
REPORT_FILE = os.path.join(PICOSOC_DIR, "report.json")

# The configurations shown in the README results table.
CONFIGS = [
    (0, 0, 0),
    (16, 0, 0),
    (16, 8, 0),
    (16, 8, 4),
]


def run_soc_pnr(n16, n8, n4):
    subprocess.run(
        ["make", "-C", HW_DIR, "clean", "synth", f"N16={n16}", f"N8={n8}", f"N4={n4}"],
        check=True,
    )
    subprocess.run(
        ["make", "-C", PICOSOC_DIR, "clean", "icebreaker_fw_bram.hex", "icebreaker.asc"],
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

    for n16, n8, n4 in CONFIGS:
        luts, fmax_mhz = run_soc_pnr(n16, n8, n4)
        row = rows.setdefault((n16, n8, n4), {"n16": n16, "n8": n8, "n4": n4})
        row["total_luts"] = luts
        row["system_fmax_mhz"] = fmax_mhz

    specs_csv.write_rows(rows)
    print(f"Wrote {len(rows)} rows to {specs_csv.SPECS_CSV}")


if __name__ == "__main__":
    main()
