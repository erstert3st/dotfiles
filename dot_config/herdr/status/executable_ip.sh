#!/usr/bin/env bash
# Primaere IP mit Verbindungstyp-Icon — Port von dreknix/tmux-primary-ip
# (scripts/helpers.sh: get_primary_ip_linux) auf herdrs tab_bar_right.
set -euo pipefail

route_str="$(ip route get 8.8.8.8 2>/dev/null | head -1 || true)"
if [[ -z "$route_str" ]]; then
  echo " no internet"
  exit 0
fi

addr="$(awk '{ for (i = 1; i < NF; i++) if ($i == "src") { print $(i + 1); exit } }' <<<"$route_str")"
dev="$(awk '{ for (i = 1; i < NF; i++) if ($i == "dev") { print $(i + 1); exit } }' <<<"$route_str")"
conn_type="$(nmcli -t -f DEVICE,TYPE connection show --active 2>/dev/null | awk -F: -v d="$dev" '$1 == d { print $2; exit }')"

case "$conn_type" in
  802-3-ethernet|ethernet)   icon='󰈀' ;;
  802-11-wireless|wifi)      icon='󰖩' ;;
  vpn|wireguard|tun)         icon='' ;;
  *)                         icon='' ;;
esac

echo "$icon ${addr:-?}"
