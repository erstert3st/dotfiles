export ANSIBLE_INVENTORY=$HOME/.ansible/hosts
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:/usr/local/bin:$HOME/.spicetify:$PATH"
export ENABLE_CORRECTION="true"
export HIST_STAMPS="dd.mm.yyyy"
export EDITOR="nano"
export ZPLUG_HOME="$HOME/.zplug"

#export ZPLUG_HOME=/opt/homebrew/opt/zplug
#export TERM="xterm-256color"
export BAT_PAGER="cat"
alias upgrade="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt clean"
alias python='python3'
alias ca='chezmoi apply'
alias caa='chezmoi apply && source ~/.zshrc && echo dotfiles updates applied'
alias codew="'/mnt/c/Users/user-win/AppData/Local/Programs/Microsoft VS Code/bin/code'"
alias ccode="chezmoi cd && codew" 
alias lzd='lazydocker'
alias ls='eza --icons=always'
# alias ls='eza --icons=auto'

#you should use add all found shortcut not only best
export YSU_MODE=ALL
export YSU_MESSAGE_FORMAT="$(tput setaf 1)$(printf '%*s' $((($(tput cols) )  / 2 - 20 )) '')🤬🤬🤬  %alias_type '%command' nutze sofort: %alias  🤬🤬🤬 $(tput sgr0)"

# eval $(thefuck --alias)
# eval $(thefuck --alias fuck)
# eval $(thefuck --alias f)
