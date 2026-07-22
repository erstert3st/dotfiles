#!/bin/bash
# Lint + render smoke tests. Requirements: shellcheck, chezmoi in PATH.
# Full end-to-end bootstrap tests live in tests/docker/ (run by CI).
set -euo pipefail
cd "$(dirname "$0")/.."
SRC="$PWD"

echo "== chezmoi data parses (.chezmoidata/*.yaml) =="
chezmoi --source "$SRC" data >/dev/null

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
if command -v shellcheck >/dev/null 2>&1; then
    sc() { shellcheck -S warning "$@"; }
else
    echo "   (no local shellcheck, falling back to koalaman/shellcheck:stable via docker)"
    sc() { docker run --rm -v "$SRC:$SRC" -v "$tmp:$tmp" -w "$SRC" koalaman/shellcheck:stable -S warning "$@"; }
fi

echo "== shellcheck: plain scripts =="
while IFS= read -r -d '' f; do
    sc "$f"
done < <(find .chezmoiscripts -name '*.sh' -print0)
sc executable_powersave.sh

echo "== shellcheck: rendered script templates (local distro context) =="
for t in .chezmoiscripts/*.sh.tmpl; do
    out="$tmp/$(basename "${t%.tmpl}")"
    chezmoi --source "$SRC" execute-template <"$t" >"$out"
    if ! grep -q '[^[:space:]]' "$out"; then
        echo "   (renders empty here, skipped: $t)"
        continue
    fi
    sc "$out"
done

echo "== chezmoi doctor (informational) =="
chezmoi --source "$SRC" doctor || echo "   doctor reported issues (non-fatal)"

echo "ALL TESTS PASSED"
