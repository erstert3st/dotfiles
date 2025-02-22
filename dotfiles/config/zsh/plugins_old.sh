ZPLUG_HOME=~/.zplug
autoload -U compinit && compinit
source ~/.zplug/init.zsh
# source  ~/.local/bin/gh-source/gh-source.zsh
fpath+=~/.zplug/repos/zsh-users/zsh-completions/src

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
plugins=(  chezmoi zoxide helm kubectl oc ssh sudo z git brew vscode dotnet python docker podman ansible macos tmux pipenv )

source $ZSH/oh-my-zsh.sh
zplug Aloxaf/fzf-tab, defer:1

zplug "zsh-users/zsh-autosuggestions", defer:1
zplug "zsh-users/zsh-syntax-highlighting", defer:1
zplug "zshzoo/cd-ls", defer:2
zplug "MichaelAquilina/zsh-you-should-use", defer:1
zplug "MichaelAquilina/zsh-autoswitch-virtualenv", defer:2
#fzf complet -> configure it https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#configure
zplug "Freed-Wu/zsh-command-not-found", defer:2
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' switch-group '<' '>'

zstyle ':omz:update' frequency 14  # 14 day cycle
#zstyle ':omz:update' mode auto      # update automatically without asking
zplug "zsh-users/zsh-completions", defer:1  # General completions
zplug "zsh-users/zsh-history-substring-search", defer:2
# zplug "hlissner/zsh-autopair", defer:1
# zplug "agkozak/zsh-z", defer:2
# zplug "zsh-users/zsh-history-substring-search", defer:2  # History substring search

#you should use add all found shortcut not only best
export YSU_MODE=ALL
export YSU_MESSAGE_FORMAT="$(tput setaf 1)$(printf '%*s' $((($(tput cols) )  / 2 - 20 )) '')🤬🤬🤬  %alias_type '%command' nutze sofort: %alias  🤬🤬🤬 $(tput sgr0)"



# Other system-specific plugins (for tools like Docker, Brew, etc.)




# 10% chance of updating zsh plugins 
if [ $((RANDOM % 5)) -eq 0 ]; then
    # printf "Install? [y/N]: "
    # if read -q; then
       #echo; zplug update
    # fi
fi

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
   zplug install
fi

# #load zplug install
# if ! zplug check --verbose; then
#     printf "Install? [y/N]: "
#     if read -q; then
#         echo; zplug install
#     fi
# fi
zplug load 
# zplug load  --verbose 
