fpath+=~/.local/completions
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# oh-my-zsh.sh used to set this; its libs/plugins cache completions here
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR/completions"
fpath+=("$ZSH_CACHE_DIR/completions")

# antidote loads everything listed in ~/.zsh_plugins.txt (chezmoi template)
source ~/.antidote/antidote.zsh
antidote load
autoload -Uz compinit && compinit

#fzf complet -> configure it https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#configure
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
#zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' popup-min-size 75 10
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

#you should use add all found shortcut not only best
export YSU_MODE=ALL
export YSU_MESSAGE_FORMAT="$(tput setaf 1)$(printf '%*s' $((($(tput cols) )  / 2 - 20 )) '')🤬🤬🤬  %alias_type '%command' nutze sofort: %alias  🤬🤬🤬 $(tput sgr0)"


[ -s "/home/user1/.bun/_bun" ] && source "/home/user1/.bun/_bun"


# plugin update: after a 14 day cooldown, ask on a random shell start (20% chance)
PLUGIN_UPDATE_STAMP="${XDG_STATE_HOME:-$HOME/.local/state}/plugins-last-ask"
if [[ ! -f "$PLUGIN_UPDATE_STAMP" || -n "$(find "$PLUGIN_UPDATE_STAMP" -mtime +14 2>/dev/null)" ]] \
   && (( RANDOM % 5 == 0 )); then
    mkdir -p "${PLUGIN_UPDATE_STAMP:h}"
    touch "$PLUGIN_UPDATE_STAMP"   # cooldown starts on the question, not the answer
    printf "update zsh + tmux plugins? [y/N]: "
    if read -q; then
       echo
       antidote update
       [[ -x ~/.tmux/plugins/tpm/bin/update_plugins ]] && ~/.tmux/plugins/tpm/bin/update_plugins all
    fi
    echo
fi
