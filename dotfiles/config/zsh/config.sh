#source $ZPLUG_HOME/init.zsh
set enable-bracketed-paste off # rm weird paste in linux
#load All
source ~/dotfiles/config/zsh/env.sh

source ~/dotfiles/config/zsh/style.sh
source ~/dotfiles/config/zsh/plugins_old.sh
alias ls='eza --icons=auto'
eval "$(zoxide init zsh)"

#  zstyle ':completion:*' menu select
#  zstyle ':completion:*' verbose yes
#  zstyle ':completion:*' use-cache on
#  zstyle ':completion:*' cache-path ~/.zsh/cache
# Check if running in VS Code terminal or already in tmux session
if [[ -z "$VSCODE_PID" && "$TERM_PROGRAM" != "vscode" && -z "$TMUX" && -z "$SSH_CONNECTION" ]]; then
  tmux new-session -A -s startup
fi
export SHOW_KUBE_CONTEXT=false
alias kubectl=kubecolor
compdef kubecolor=kubectl