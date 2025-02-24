source ~/dotfiles/config/zsh/env.sh
source $ZPLUG_HOME/init.zsh
autoload -U compinit && compinit
set enable-bracketed-paste off # rm weird paste in linux
#load All

source ~/dotfiles/config/zsh/plugins_old.sh
source ~/dotfiles/config/zsh/style.sh


 zstyle ':completion:*' menu select
 zstyle ':completion:*' verbose yes
 zstyle ':completion:*' use-cache on
 zstyle ':completion:*' cache-path ~/.zsh/cache

 if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
  # tmux
fi