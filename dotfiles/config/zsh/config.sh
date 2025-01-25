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
source ~/dotfiles/config/zsh/style.sh
source ~/dotfiles/config/zsh/plugins_old.sh
eval $(thefuck --alias)
eval $(thefuck --alias fuck)
eval $(thefuck --alias f)

 zstyle ':completion:*' menu select
 zstyle ':completion:*' verbose yes
 zstyle ':completion:*' use-cache on
 zstyle ':completion:*' cache-path ~/.zsh/cache