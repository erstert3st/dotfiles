source ~/dotfiles/config/zsh/style.sh
#export PATH=$PATH:/home/user1/.spicetify

# Advanced command-not-found hook
if [[ -f /usr/share/doc/find-the-command/ftc.bash ]]; then
    source /usr/share/doc/find-the-command/ftc.bash
fi



command -v apt >/dev/null 2>&1 && alias upgrade="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt clean"
alias python='python3'
alias k9ss='command k9s'

##arch
alias cats='cat --style=plain'
#alias cd='z'
alias tree='eza --icons=auto --tree'
alias ca='chezmoi apply'
alias cu='chezmoi update'
alias caa='chezmoi update && source ~/.zshrc && echo dotfiles updates applied'
alias caat='chezmoi update  && source ~/.zshrc && tmux source-file ~/.tmux.conf && echo dotfiles updates applied'
alias codew="'/mnt/c/Users/user-win/AppData/Local/Programs/Microsoft VS Code/bin/code'"
alias ccode="chezmoi cd && code"
# eval $(thefuck --alias)
# eval $(thefuck --alias fuck)
# eval $(thefuck --alias f)
if command -v kubecolor >/dev/null 2>&1; then
    alias kubectl="export SHOW_KUBE_CONTEXT=true; kubecolor"
else
    alias kubectl="export SHOW_KUBE_CONTEXT=true; kubectl"
fi
alias helm="export SHOW_KUBE_CONTEXT=true; helm"
alias k9s="export SHOW_KUBE_CONTEXT=true; k9s"
alias fluxA='flux get helmreleases -A && echo -e "\n\n----------------- kustomizations ------------------------\n\n" && flux get kustomizations -A'

## Useful aliases

# Replace ls with eza
if command -v eza >/dev/null 2>&1; then
    alias ls='eza  --color=always --group-directories-first --icons'     # preferred listing
    alias la='eza -a --git --color=always --group-directories-first --icons'      # all files and dirs
    alias ll='eza -l --git --color=always --group-directories-first --icons'      # long format
    alias lll='eza -la --git --color=always --group-directories-first --icons'      # long format
    alias lt='eza -aT --git --color=always --group-directories-first --icons'     # tree listing
    alias l.='eza -ald --git --color=always --group-directories-first --icons .*' # show only dotfiles
else
    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lll='ls -la'
    alias lt='ls --tree'
fi


! command -v yay >/dev/null 2>&1 && command -v paru >/dev/null 2>&1 && alias yay='paru'
if grep -Eq '^ID="?arch"?$|^ID_LIKE=.*arch' /etc/os-release 2>/dev/null; then
    is_arch=true
    
    # export NO_TMUX=1
    # Common use
    alias fixpacman="sudo rm /var/lib/pacman/db.lck"
    alias rmpkg="sudo pacman -Rdd"
    if command -v garuda-update >/dev/null 2>&1; then
        alias upd='garuda-update'
    else
        alias upd='sudo pacman -Syu'
    fi
    alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
    # Get fastest mirrors
    alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
    alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
    alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
    alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"
    # Help people new to Arch
    alias apt='man pacman'
    alias apt-get='man pacman'
    alias pacdiff='sudo -H DIFFPROG=meld pacdiff'
    alias tb='nc termbin.com 9999'
    alias helpme='cht.sh --shell'
    # Cleanup orphaned packages
    alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
fi

alias tarnow='tar -acf '
alias untar='tar -xvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='ugrep --color=auto'
alias fgrep='ugrep -F --color=auto'
alias egrep='ugrep -E --color=auto'
alias hw='hwinfo --short'                          # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"     # Sort installed packages according to size in MB (expac must be installed)
alias pic="chafa"                            # Display images in terminal (chafa must be installed)
alias pica="chafa -f symbols --symbols ascii" # Display images in terminal using ascii symbols (chafa must be installed)

alias please='sudo'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

alldirs() {
  for d in */; do
    (cd "$d" && "$@")
  done
}

# herdr-mirror: nach jedem Reboot einmal den Key in den ssh-agent laden (Passphrase).
# SSH_AUTH_SOCK wird in env.sh gesetzt, daher genügt hier plain ssh-add.
alias mirror-key='ssh-add ~/.ssh/id_ed25519'

# Headless-Boot: GUI bei Bedarf starten (SDDM wechselt selbst aufs richtige VT).
alias gui='sudo systemctl start sddm.service'

# copy/clip: Dateiinhalt (oder stdin) in die Zwischenablage.
#   copy datei.txt          # Datei kopieren
#   cmd | clip              # Pipe kopieren
# Backend wird bei jedem Aufruf ermittelt, weil dieselbe Shell mal unter
# Wayland, mal auf einer Text-Konsole laufen kann.
copy() {
    local backend
    if [ -n "$WSL_DISTRO_NAME" ] && command -v clip.exe >/dev/null 2>&1; then
        backend=(clip.exe)
    elif [ -n "$WAYLAND_DISPLAY" ] && command -v wl-copy >/dev/null 2>&1; then
        backend=(wl-copy)
    elif [ -n "$DISPLAY" ] && command -v xclip >/dev/null 2>&1; then
        backend=(xclip -selection clipboard)
    elif [ -n "$DISPLAY" ] && command -v xsel >/dev/null 2>&1; then
        backend=(xsel --clipboard --input)
    else
        echo "copy: kein Clipboard-Backend gefunden (wl-copy/xclip/xsel/clip.exe)" >&2
        return 1
    fi

    if [ "$#" -eq 0 ]; then
        "${backend[@]}"
    elif [ "$#" -gt 1 ]; then
        echo "copy: erwartet genau eine Datei oder stdin" >&2
        return 1
    elif [ -r "$1" ] && [ ! -d "$1" ]; then
        "${backend[@]}" <"$1"
    else
        echo "copy: Datei nicht lesbar: $1" >&2
        return 1
    fi
}
# Funktion statt Alias: Aliase werden in nicht-interaktiven Shells nicht expandiert.
clip() { copy "$@"; }

# herdr-lazy: das Plugin-Binary liegt in einem hash-benannten Ordner unter
# ~/.config/herdr/plugins/github/, daher den Pfad zur Laufzeit aus 'plugin list --json'
# (Feld plugin_root) auflösen statt ihn fest zu verdrahten.
herdr-lazy() {
    local root
    root=$(herdr plugin list --json | python3 -c \
        "import json,sys;print([p['plugin_root'] for p in json.load(sys.stdin)['result']['plugins'] if p['plugin_id']=='herdr-lazy'][0])") || {
        echo "herdr-lazy: Plugin nicht installiert (herdr plugin install …)" >&2
        return 1
    }
    "$root/target/release/herdr-lazy" "$@"
}
