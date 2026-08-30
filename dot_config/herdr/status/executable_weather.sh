#!/usr/bin/env bash
# Wetter von wttr.in — Adaption von xamut/tmux-weather (format=1, metrisch,
# Standort per Geo-IP). Cache, damit ein Netzfehler das Segment nicht leert:
# herdr verwirft den Wert bei leerer Ausgabe oder Timeout.
set -euo pipefail

cache="${XDG_CACHE_HOME:-$HOME/.cache}/herdr-weather"

if value="$(curl -sf --max-time 8 'https://wttr.in/?m&format=1' | sed 's/\xEF\xB8\x8F//g; s/[[:space:]]km/km/g')" \
   && [[ -n "${value// /}" ]]; then
  printf '%s' "$value" > "$cache"
fi

[[ -r "$cache" ]] && cat "$cache"
