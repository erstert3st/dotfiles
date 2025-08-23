export ANSIBLE_INVENTORY=$HOME/.ansible/hosts
export ZSH="$HOME/.oh-my-zsh"

export ENABLE_CORRECTION="true"
export HIST_STAMPS="dd.mm.yyyy"
export EDITOR="nano"
#export STARSHIP_CONFIG=$HOME/.Dotfiles/starship/starship.toml
#export ZPLUG_HOME=/opt/homebrew/opt/zplug
export TERM="xterm-256color"
export LESS='-RM'
export BAT_PAGER="cat"
export BAT_THEME="Visual Studio Dark+"

#  TERM=xterm-256color

if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" == "debian" ]]; then
        alias cats='batcat'
    # elif [[ "$ID" == "ubuntu" ]]; then
    #     echo "This is Ubuntu"
    fi
else
    alias cat='bat'

fi
 export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# if [[ "$OSTYPE" == "darwin"* ]]; then
#     echo "You are on a Mac"
# else
#     echo "You are not on a Mac"
# fi



function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}