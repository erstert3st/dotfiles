export ANSIBLE_INVENTORY=$HOME/.ansible/hosts
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:/usr/local/bin:$HOME/.spicetify:$PATH"
export ENABLE_CORRECTION="true"
export HIST_STAMPS="dd.mm.yyyy"
export EDITOR="nano"
#export STARSHIP_CONFIG=$HOME/.Dotfiles/starship/starship.toml
#export ZPLUG_HOME=/opt/homebrew/opt/zplug
#export TERM="xterm-256color"
export BAT_PAGER="cat"
alias upgrade="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt clean"
alias python='python3'
alias ls='eza --icons=auto'
alias ca='chezmoi apply'
alias cu='chezmoi update'
alias caa='chezmoi apply && source ~/.zshrc && echo dotfiles updates applied'
alias caat='chezmoi apply && source ~/.zshrc && tmux source-file ~/.tmux.conf && echo dotfiles updates applied'
alias codew="'/mnt/c/Users/user-win/AppData/Local/Programs/Microsoft VS Code/bin/code'"
alias ccode="chezmoi cd && codew" 
# eval $(thefuck --alias)
# eval $(thefuck --alias fuck)
# eval $(thefuck --alias f)
