source ~/dotfiles/config/zsh/style.sh
#export PATH=$PATH:/home/user1/.spicetify

# Advanced command-not-found hook
if [[ -f /usr/share/doc/find-the-command/ftc.bash ]]; then
  source /usr/share/doc/find-the-command/ftc.bash
fi


alias ls='eza --icons=auto'
alias kubectl=kubecolor
alias upgrade="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt clean"
alias python='python3'
alias k9ss='/usr/bin/k9s'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lll='ls -la'
alias lt='ls --tree'

##arch

#alias cd='z'
alias tree='eza --icons=auto --tree'
alias cats='cats --style=plain'
alias ca='chezmoi apply'
alias cu='chezmoi update'
alias caa='chezmoi apply && source ~/.zshrc && echo dotfiles updates applied'
alias caat='chezmoi apply && source ~/.zshrc && tmux source-file ~/.tmux.conf && echo dotfiles updates applied'
alias codew="'/mnt/c/Users/user-win/AppData/Local/Programs/Microsoft VS Code/bin/code'"
alias ccode="chezmoi cd && codew" 
# eval $(thefuck --alias)
# eval $(thefuck --alias fuck)
# eval $(thefuck --alias f)
alias kubectl="export SHOW_KUBE_CONTEXT=true; kubectl"
alias helm="export SHOW_KUBE_CONTEXT=true; helm"
alias k9s="export SHOW_KUBE_CONTEXT=true; k9s"

## Useful aliases

# Replace ls with eza
if [[ -x /usr/bin/eza ]]; then
  alias ls='eza -al --color=always --group-directories-first --icons'     # preferred listing
  alias la='eza -a --color=always --group-directories-first --icons'      # all files and dirs
  alias ll='eza -l --color=always --group-directories-first --icons'      # long format
  alias lt='eza -aT --color=always --group-directories-first --icons'     # tree listing
  alias l.='eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles
fi


# Replace some more things with better alternatives
if [[ -x /usr/bin/bat ]]; then
  alias cat='bat --style header --style snip --style changes --style header'
fi

[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'
if [[ -f /etc/arch-release ]] || grep -q "Arch Linux" /etc/os-release 2>/dev/null; then
    is_arch=true

    # export NO_TMUX=1
    # Common use
    alias fixpacman="sudo rm /var/lib/pacman/db.lck"
    alias rmpkg="sudo pacman -Rdd"
    alias upd='/usr/bin/garuda-update'
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
alias untar='tar -zxvf '
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



alias please='sudo'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"