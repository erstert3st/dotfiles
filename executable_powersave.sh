#!/usr/bin/env bash
# Umschalter Low-Power <-> Performance
#   Getestet auf:
#     * Mini-PC SER8 : Ryzen 7 8745HS + Radeon 780M (iGPU), CachyOS  (mit EPP)
#     * Desktop      : Ryzen 7 9800X3D, B850I, AMD-iGPU + NVIDIA dGPU (ohne EPP)
#   low   : CPU powersave/EPP power   + amdgpu DPM low   (kuehl, leise)
#   high  : CPU performance/EPP perf  + amdgpu DPM auto  (volle Leistung)
# Passt sich der Hardware an: EPP nur wenn vorhanden, amdgpu nur wenn gefunden.
# Aufruf:  powersave.sh [low|high]   (ohne Arg -> interaktive Abfrage)
set -euo pipefail

# --- Maschine erkennen (nur informativ, kein Abbruch) ---------------------
PRODUCT=$(cat /sys/class/dmi/id/product_name 2>/dev/null || true)
CPU=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | xargs)
if [[ ! -e /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]]; then
    echo "Abbruch: kein cpufreq-Interface gefunden -- Hardware nicht unterstuetzt."
    echo "Erkannt: product='$PRODUCT', CPU='$CPU'"
    exit 1
fi

# --- amdgpu-Karte finden ---------------------------------------------------
find_amdgpu() {
    local d
    for d in /sys/class/drm/card*/device; do
        [[ "$(cat "$d/vendor" 2>/dev/null)" == 0x1002 ]] || continue
        [[ -f "$d/power_dpm_force_performance_level" ]] || continue
        echo "$d"; return 0
    done
    return 1
}
amdgpu_temp() {
    local h
    for h in /sys/class/hwmon/hwmon*; do
        [[ "$(cat "$h/name" 2>/dev/null)" == amdgpu ]] || continue
        awk '{printf "%.0f C", $1/1000}' "$h/temp1_input" 2>/dev/null && return
    done
    echo "n/a"
}
cpu_temp() {
    local h
    for h in /sys/class/hwmon/hwmon*; do
        [[ "$(cat "$h/name" 2>/dev/null)" == k10temp ]] || continue
        awk '{printf "%.0f C", $1/1000}' "$h/temp1_input" 2>/dev/null && return
    done
    echo "n/a"
}

# --- Status-Anzeige --------------------------------------------------------
show_status() {
    local gov epp d dpm sclk m
    gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    epp=$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null || echo "n/a")
    d=$(find_amdgpu) || true
    dpm=$([[ -n "$d" ]] && cat "$d/power_dpm_force_performance_level" || echo "n/a")
    sclk=$([[ -n "$d" ]] && grep '\*' "$d/pp_dpm_sclk" 2>/dev/null | awk '{print $2}' || echo "")
    m="?"; [[ "$gov" == powersave ]] && m="low-power"; [[ "$gov" == performance ]] && m="high-performance"
    echo   "--------------------------------------------------"
    echo   "  Modus jetzt : $m"
    printf "  CPU         : %-11s EPP=%-11s Temp=%s\n" "$gov" "$epp" "$(cpu_temp)"
    printf "  amdgpu      : DPM=%-9s %-10s Temp=%s\n" "$dpm" "$sclk" "$(amdgpu_temp)"
    echo   "--------------------------------------------------"
}

# --- Modus bestimmen -------------------------------------------------------
MODE="${1:-}"
if [[ -z "$MODE" ]]; then
    show_status
    read -rp "Modus? [l]ow-power / [h]igh-performance: " ans
    case "$ans" in
        h|high|H) MODE="high" ;;
        *)        MODE="low"  ;;
    esac
fi
case "$MODE" in
    low|l)   GOV=powersave;   EPP=power;       DPM=low  ;;
    high|h)  GOV=performance; EPP=performance; DPM=auto ;;
    *) echo "Unbekannter Modus: $MODE  (erlaubt: low | high)"; exit 1 ;;
esac

# --- Anwenden (braucht Root) ----------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo "Root noetig -> sudo ..."
    exec sudo "$0" "$MODE"
fi

for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo "$GOV" > "$g"; done

# EPP nur setzen, wenn das Interface existiert (amd_pstate active/EPP-Modus).
# Auf CPUs ohne EPP (z.B. acpi-cpufreq) fehlt das File -> ueberspringen.
epp_set=0
for e in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
    [[ -w "$e" ]] || continue
    echo "$EPP" > "$e"; epp_set=1
done
[[ "$epp_set" -eq 0 ]] && echo "Hinweis: kein EPP-Interface -> nur Governor gesetzt."

D=$(find_amdgpu) || true
if [[ -n "$D" ]]; then
    echo "$DPM" > "$D/power_dpm_force_performance_level"
else
    echo "Warnung: keine amdgpu-Karte gefunden -> GPU-Teil uebersprungen"
fi

echo "=== Modus '$MODE' gesetzt ==="
show_status
