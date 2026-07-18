#!/bin/bash

# Installiert die herdr-Plugins reproduzierbar via 'herdr plugin install'
# (statt die gebauten Plugin-Binaries per chezmoi zu syncen — die liegen in
# hash-benannten Ordnern und werden pro Plattform frisch gebaut).
# Idempotent: bereits installierte Plugins werden übersprungen.

if ! command -v herdr >/dev/null 2>&1; then
    echo "herdr not available, skipping plugin install"
    exit 0
fi

install_plugin() {
    # $1 = owner/repo   $2 = plugin_id   $3.. = extra args (z.B. --ref v0.3.2)
    local repo="$1" id="$2"; shift 2
    if herdr plugin list --json 2>/dev/null | grep -q "\"plugin_id\":\"$id\""; then
        echo "herdr plugin $id already installed"
    else
        echo "installing herdr plugin $repo"
        herdr plugin install "$repo" "$@" --yes
    fi
}

# Plugins hier ergänzen (owner/repo  plugin_id  [extra args]).
install_plugin "smarzban/herdr-file-viewer"    "herdr-file-viewer"
install_plugin "nikok6/herdr-mirror"           "mirror"
install_plugin "rjyo/herdr-window-title-sync"  "rjyo.window-title-sync"
install_plugin "den-tanui/herdr-zoxide"        "herdr-zoxide"
install_plugin "bcihanc/herdr-claude-session-title" "bcihanc.claude-session-title"
# TODO: herdr-navigator baut aus Rust-Quellen (braucht 'cargo'). Zeile aktivieren,
#       sobald Rust installiert ist (plugin_id ggf. nach erstem Install verifizieren):
# install_plugin "thanhdat77/herdr-navigator"    "navigator" --ref v0.3.2

# Config nach Plugin-Installs neu laden, damit Actions verfügbar sind.
herdr server reload-config >/dev/null 2>&1 || true

# claude-session-title: legt seinen Claude-Code-Hook (~/.claude/hooks/...) via
# 'install'-Action an. Das settings.json-Template rendert die Hooks nur, wenn die
# .sh existiert — daher hier einmalig erzeugen.
if [ ! -f "$HOME/.claude/hooks/herdr-claude-session-title.sh" ]; then
    herdr plugin action invoke install --plugin bcihanc.claude-session-title >/dev/null 2>&1 || true
fi
