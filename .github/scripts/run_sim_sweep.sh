#!/usr/bin/env bash
# Runs `make <target>` for every N16/N8/N4 combination that is structurally
# distinct per multiplier size. Not a blind cross product: Config4x4Mul only
# exposes N4, Config8x8Mul only exposes N8/N4, 2x2 has no N-parameters at
# all, and only Config16x16Mul uses all three - see hw-sim.yml for details.
#
# Usage: run_sim_sweep.sh [target]
#   target: make target to run per combination, e.g. `sim` (default) or
#   `sim-synth`. 2x2 is skipped for any target other than `sim`, since its
#   two modules (Accurate2x2Mul/Approx2x2Mul) are fixed leaves rather than a
#   parameterized Config*Mul module and have no synth/sim-synth target.
#
# Assumes Python (for the golden model) and the OSS CAD Suite (yosys,
# iverilog, vvp) are already on PATH. Works the same way in CI or locally.
set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

target="${1:-sim}"

# dir n16 n8 n4
combos=(
  "2x2    0  0 0"
  "4x4    0  0 0"
  "4x4    0  0 4"
  "8x8    0  0 0"
  "8x8    0  0 4"
  "8x8    0  8 0"
  "8x8    0  8 4"
  "16x16  0  0 0"
  "16x16  0  0 4"
  "16x16  0  8 0"
  "16x16  0  8 4"
  "16x16 16  0 0"
  "16x16 16  0 4"
  "16x16 16  8 0"
  "16x16 16  8 4"
)

failures=()
ran=0

for combo in "${combos[@]}"; do
  read -r dir n16 n8 n4 <<< "$combo"

  if [ "$dir" = "2x2" ] && [ "$target" != "sim" ]; then
    continue
  fi

  ran=$((ran + 1))
  echo "::group::HW/MUL/$dir $target (N16=$n16 N8=$n8 N4=$n4)"
  if make -C "HW/MUL/$dir" clean "$target" N16="$n16" N8="$n8" N4="$n4"; then
    echo "PASS: $dir $target N16=$n16 N8=$n8 N4=$n4"
  else
    echo "FAIL: $dir $target N16=$n16 N8=$n8 N4=$n4"
    failures+=("$dir $target (N16=$n16 N8=$n8 N4=$n4)")
  fi
  echo "::endgroup::"
done

if [ "${#failures[@]}" -gt 0 ]; then
  echo "Failed configurations:"
  printf '  - %s\n' "${failures[@]}"
  exit 1
fi

echo "All $ran configurations passed for target '$target'."
