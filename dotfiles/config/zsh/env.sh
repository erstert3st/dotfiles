export ANSIBLE_INVENTORY=$HOME/.ansible/hosts
export ZSH="$HOME/.oh-my-zsh"
export PATH="/usr/bin/:$HOME/.local/bin:/usr/local/bin:$HOME/.spicetify:$PATH"
export ENABLE_CORRECTION="true"
export HIST_STAMPS="dd.mm.yyyy"
export EDITOR="nano"
#export STARSHIP_CONFIG=$HOME/.Dotfiles/starship/starship.toml
#export ZPLUG_HOME=/opt/homebrew/opt/zplug
export TERM="xterm-256color"
export LESS='-RM'
export BAT_PAGER="cat"
export BAT_THEME="Visual Studio Dark+"
alias upgrade="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt clean"
alias python='python3'
alias k9ss='/usr/bin/k9s'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lll='ls -la'
alias lt='ls --tree'
#  TERM=xterm-256color
#alias cd='z'
alias tree='eza --icons=auto --tree'
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" == "debian" ]]; then
        alias cats='batcat'
    # elif [[ "$ID" == "ubuntu" ]]; then
    #     echo "This is Ubuntu"
    fi
else
    alias cat='bat'

fi
 export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# if [[ "$OSTYPE" == "darwin"* ]]; then
#     echo "You are on a Mac"
# else
#     echo "You are not on a Mac"
# fi

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

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}