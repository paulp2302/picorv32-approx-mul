#!/usr/bin/env bash
# Runs `make <target>` for selected N16/N8/N4/APPROX combinations.
#
# Usage: run_sim_sweep.sh [target]
#   target: make target to run per combination, e.g. `sim` (default) or
#   `sim-synth`. N16/N8/N4 are unused 2x2, and APPROX is unused for 
#   everything else.
#
# Assumes Python (for the golden model) and the OSS CAD Suite (yosys,
# iverilog, vvp) are already on PATH. Works the same way in CI or locally.
set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

target="${1:-sim}"

# dir n16 n8 n4 approx
combos=(
  "2x2    0  0 0 0"
  "2x2    0  0 0 1"
  "4x4    0  0 0 0"
  "4x4    0  0 4 0"
  "8x8    0  0 0 0"
  "8x8    0  0 4 0"
  "8x8    0  8 0 0"
  "8x8    0  8 4 0"
  "16x16  0  0 0 0"
  "16x16  0  0 4 0"
  "16x16  0  8 0 0"
  "16x16  0  8 4 0"
  "16x16 16  0 0 0"
  "16x16 16  0 4 0"
  "16x16 16  8 0 0"
  "16x16 16  8 4 0"
)

failures=()
ran=0

for combo in "${combos[@]}"; do
  read -r dir n16 n8 n4 approx <<< "$combo"

  ran=$((ran + 1))
  echo "::group::HW/MUL/$dir $target (N16=$n16 N8=$n8 N4=$n4 APPROX=$approx)"
  if make -C "HW/MUL/$dir" clean "$target" N16="$n16" N8="$n8" N4="$n4" APPROX="$approx"; then
    echo "PASS: $dir $target N16=$n16 N8=$n8 N4=$n4 APPROX=$approx"
  else
    echo "FAIL: $dir $target N16=$n16 N8=$n8 N4=$n4 APPROX=$approx"
    failures+=("$dir $target (N16=$n16 N8=$n8 N4=$n4 APPROX=$approx)")
  fi
  echo "::endgroup::"
done

if [ "${#failures[@]}" -gt 0 ]; then
  echo "Failed configurations:"
  printf '  - %s\n' "${failures[@]}"
  exit 1
fi

echo "All $ran configurations passed for target '$target'."
