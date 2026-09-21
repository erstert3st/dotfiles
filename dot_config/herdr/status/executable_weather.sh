#!/usr/bin/env bash
# Wetter von wttr.in — Adaption von xamut/tmux-weather (format=1, metrisch).
# Standort: $HERDR_WEATHER_LOCATION (Ortsname oder "48.21,16.37"), Default "Wien".
# Ohne Default würde wttr.in die Station per Geo-IP der öffentlichen Adresse wählen
# — bei --remote/mirror wäre das die IP der Gegenseite.
# herdr startet Segment-Kommandos als Login-Shell (/bin/sh -lc), darum genügt
# ein export in ~/.profile — greift ohne Server-Neustart beim nächsten Tick.
# Cache, damit ein Netzfehler das Segment nicht leert: herdr verwirft den Wert
# bei leerer Ausgabe oder Timeout.
set -euo pipefail

location="${HERDR_WEATHER_LOCATION:-Wien}"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/herdr-weather"

# sed: Variation-Selector-16 raus (U+FE0F), Padding der API auf ein Leerzeichen
# kollabieren, Rand-Leerzeichen weg.
if value="$(curl -sf --max-time 8 "https://wttr.in/${location// /+}?m&format=1" \
            | sed 's/\xEF\xB8\x8F//g; s/[[:space:]]\{1,\}/ /g; s/ km/km/g; s/^ //; s/ $//')" \
   && [[ -n "${value// /}" ]]; then
  printf '%s' "$value" > "$cache"
fi

[[ -r "$cache" ]] && cat "$cache"
