#!/usr/bin/env bash
# CPU-Auslastung in Prozent — Adaption von tmux-cpu (#{cpu_percentage}),
# Icon wie in ~/.tmux/plugins/tmux/custom_modules/ctp_cpu.conf.
set -euo pipefail

sample() { awk '/^cpu /{print $2+$3+$4+$5+$6+$7+$8, $5+$6}' /proc/stat; }

read -r total_a idle_a < <(sample)
sleep 0.3
read -r total_b idle_b < <(sample)

awk -v ta="$total_a" -v ia="$idle_a" -v tb="$total_b" -v ib="$idle_b" \
  'BEGIN { dt = tb - ta; di = ib - ia; printf " %.0f%%\n", (dt > 0) ? 100 * (dt - di) / dt : 0 }'
