export ANSIBLE_INVENTORY=$HOME/.ansible/hosts
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:/usr/local/bin:$HOME/.spicetify:$PATH"
export ENABLE_CORRECTION="true"
export HIST_STAMPS="dd.mm.yyyy"
export EDITOR="nano"
export STARSHIP_CONFIG=$HOME/.Dotfiles/starship/starship.toml
export ZPLUG_HOME=/opt/homebrew/opt/zplug
export TERM="xterm-256color"
export BAT_PAGER="cat"
source $ZPLUG_HOME/init.zsh

#load All
source $HOME/.Dotfiles/zsh/style.sh
source $HOME/.Dotfiles/zsh/plugins_old.sh
eval $(thefuck --alias)
eval $(thefuck --alias fuck)
eval $(thefuck --alias f)

