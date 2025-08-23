#!/bin/bash
#Todo get rid off oh my zsh -> 

if [ ! -d "$ZPLUG_HOME" ] || [ -z "$(ls -A "$ZPLUG_HOME" 2>/dev/null)" ]; then
	export ZPLUG_HOME=/$HOME/.zplug
	ZPLUG_HOME=$HOME/.zplug
	rm -rf "$ZPLUG_HOME"
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
	echo "Zplug is now installed."
else
	echo "Zplug is available."
fi


if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "Getting ohmyz.sh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc --skip-chsh
else
	echo ".oh-my-zsh already found, skipping."
fi
