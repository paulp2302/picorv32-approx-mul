#!/usr/bin/env python3
"""Regenerates the Markdown table between the SPECS_TABLE:START/END markers
in README.md from specs.csv."""
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import specs_csv  # noqa: E402

README = os.path.join(specs_csv.REPO_ROOT, "README.md")
START_MARKER = "<!-- SPECS_TABLE:START -->"
END_MARKER = "<!-- SPECS_TABLE:END -->"

# iCE40 UP5k logic cell capacity, used to compute the LUT utilization
# percentages shown alongside the raw counts.
UP5K_TOTAL_LUTS = 5280


def format_luts(value):
    return f"{value} ({int(value / UP5K_TOTAL_LUTS * 100)}%)"


def format_mhz(value):
    return f"{value:.2f} MHz"


def format_pct(fraction):
    pct = round(fraction * 100, 1)
    if pct >= 100 or pct == int(pct):
        return f"{pct:.0f}%"
    return f"{pct:.1f}%"


# (row label, column key, formatter)
ROWS = [
    ("Mul LUTs", "mul_luts", format_luts),
    ("Total LUTs (PicoRV32 + Mul)", "total_luts", format_luts),
    ("Isolated Fmax", "isolated_fmax_mhz", format_mhz),
    ("System Clock (Fmax, PicoRV)", "system_fmax_mhz", format_mhz),
    ("Median Relative Error", "median_relative_error", format_pct),
    ("Max Relative Error", "max_relative_error", format_pct),
]


def render_table(rows):
    configs = specs_csv.CONFIGS
    header = "| Metric | " + " | ".join(f"N16={n16}, N8={n8}, N4={n4}" for n16, n8, n4 in configs) + " |"
    divider = "|---" * (len(configs) + 1) + "|"

    lines = [header, divider]
    for label, key, fmt in ROWS:
        cells = []
        for config in configs:
            value = rows.get(config, {}).get(key)
            cells.append(fmt(value) if value not in (None, "") else "N/A")
        lines.append(f"| {label} | " + " | ".join(cells) + " |")
    return "\n".join(lines)


def main():
    rows = specs_csv.load_rows()
    table = render_table(rows)

    with open(README) as f:
        content = f.read()

    start = content.index(START_MARKER) + len(START_MARKER)
    end = content.index(END_MARKER)
    new_content = content[:start] + "\n" + table + "\n" + content[end:]

    with open(README, "w") as f:
        f.write(new_content)

    print(f"Updated {README}")


if __name__ == "__main__":
    main()
