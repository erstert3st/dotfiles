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
source $ZPLUG_HOME/init.zsh
autoload -U compinit && compinit

#load All

alias python='python3'
alias ls='eza'
alias ca='chezmoi apply'
alias caa='chezmoi apply && source ~/.zshrc && echo dotfiles updates applied'
alias codew="'/mnt/c/Users/user-win/AppData/Local/Programs/Microsoft VS Code/bin/code'"
alias ccode="chezmoi cd && codew" 
eval $(thefuck --alias)
eval $(thefuck --alias fuck)
eval $(thefuck --alias f)

source ~/dotfiles/config/zsh/style.sh
source ~/dotfiles/config/zsh/plugins_old.sh

if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
  tmux
fi


# eval $(chezmoi apply && source ~/.zshrc --alias  caa)
# eval $(chezmoi apply --alias  ca)

 zstyle ':completion:*' menu select
 zstyle ':completion:*' verbose yes
 zstyle ':completion:*' use-cache on
 zstyle ':completion:*' cache-path ~/.zsh/cache