
#load p10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Powerlevel10k theme
if [[ -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
else
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
fi
ZSH_THEME=""
eval "$(starship init zsh)"


# starship
# Display time
SPACESHIP_TIME_SHOW=true

# Display username always
SPACESHIP_USER_SHOW=always

# Do not truncate path in repos
SPACESHIP_DIR_TRUNC_REPO=false
