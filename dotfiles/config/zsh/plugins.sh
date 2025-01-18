source $ZSH/oh-my-zsh.sh
# source  ~/.local/bin/gh-source/gh-source.zsh
source $HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh



zsh_plugins="~.Dotfiles/zsh/plugins"

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=(/path/to/antidote/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source your static plugins file.
source ${zsh_plugins}.zsh


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
source /path-to-antidote/antidote.zsh
antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
antidote update
antidote apply
