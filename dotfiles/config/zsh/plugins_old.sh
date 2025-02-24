# source  ~/.local/bin/gh-source/gh-source.zsh
fpath+=~/.zplug/repos/zsh-users/zsh-completions/src

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:1
zplug "zshzoo/cd-ls", defer:2
zplug "MichaelAquilina/zsh-you-should-use", defer:1
zplug "MichaelAquilina/zsh-autoswitch-virtualenv", defer:2
#fzf complet -> configure it https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#configure
zplug Aloxaf/fzf-tab, defer:2
zplug "Freed-Wu/zsh-command-not-found", defer:2
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
# zstyle ':completion:*' menu no
zplug "zsh-users/zsh-completions", defer:1  # General completions
zplug "zsh-users/zsh-history-substring-search", defer:2
# zplug "hlissner/zsh-autopair", defer:1
# zplug "agkozak/zsh-z", defer:2
# zplug "zsh-users/zsh-history-substring-search", defer:2  # History substring search




# Other system-specific plugins (for tools like Docker, Brew, etc.)
plugins=( thefuck git brew vscode dotnet python docker podman ansible macos tmux pipenv )
#  zplug "plugins/git", from:oh-my-zsh, defer:2
#  zplug "plugins/brew", from:oh-my-zsh, defer:2
#  zplug "plugins/macos", from:oh-my-zsh, defer:2
#  zplug "plugins/vscode", from:oh-my-zsh, defer:2
#  zplug "plugins/dotnet", from:oh-my-zsh, defer:2
#  zplug "plugins/python", from:oh-my-zsh, defer:2
#  zplug "plugins/docker", from:oh-my-zsh, defer:2
#  zplug "plugins/podman", from:oh-my-zsh, defer:2
#  zplug "plugins/ansible", from:oh-my-zsh, defer:2
source $ZSH/oh-my-zsh.sh

#update oh my zsh
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 14  # 14 day cycle

# 10% chance of updating zsh plugins 
if [ $((RANDOM % 5)) -eq 0 ]; then
    # printf "Install? [y/N]: "
    # if read -q; then
   #     echo; zplug update
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
