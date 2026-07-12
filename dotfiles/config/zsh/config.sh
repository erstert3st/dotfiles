#source $ZPLUG_HOME/init.zsh
# set enable-bracketed-paste off # rm weird paste in linux
#load All
source ~/dotfiles/config/zsh/path.sh
source ~/dotfiles/config/zsh/env.sh

source ~/dotfiles/config/zsh/plugins_old.sh
source ~/dotfiles/config/zsh/alias.sh


eval "$(zoxide init zsh)"

#  zstyle ':completion:*' menu select
#  zstyle ':completion:*' verbose yes
#  zstyle ':completion:*' use-cache on
#  zstyle ':completion:*' cache-path ~/.zsh/cache
# Start $STARTUP_MUX (see env.sh) unless in VS Code, over SSH, or already inside a multiplexer.
# STARTUP_MUX_ACTIVE is exported *before* the launch, so every shell the multiplexer spawns
# inherits it and skips this block. herdr sets no $TMUX-style marker of its own, so without
# this the spawned shell would start herdr again, forever.
if [[ -o interactive && -n "$STARTUP_MUX" && -z "$STARTUP_MUX_ACTIVE" \
      && -z "$VSCODE_PID" && "$TERM_PROGRAM" != "vscode" \
      && -z "$TMUX" && -z "$SSH_CONNECTION" && -z "$NO_TMUX" ]] \
   && (( $+commands[${STARTUP_MUX%% *}] )); then
  export STARTUP_MUX_ACTIVE=1
  eval "$STARTUP_MUX"
fi
export SHOW_KUBE_CONTEXT=false
# (( $+commands[kubecolor] )) && (( $+commands[kubectl] )) && compdef kubecolor=kubectl