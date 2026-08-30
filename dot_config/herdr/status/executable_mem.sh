#!/usr/bin/env bash
# RAM-Auslastung in Prozent — Adaption von tmux-cpu (#{ram_percentage}),
# Icon wie in ~/.tmux/plugins/tmux/custom_modules/ctp_memory.conf.
set -euo pipefail

awk '/^MemTotal:/ { total = $2 } /^MemAvailable:/ { avail = $2 }
     END { printf " %.0f%%\n", (total > 0) ? 100 * (total - avail) / total : 0 }' /proc/meminfo
