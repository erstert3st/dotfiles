#!/bin/bash

if [ ! -d "$HOME/.zplug" ]; then
	export ZPLUG_HOME=/$HOME/.zplug
	ZPLUG_HOME=$HOME/.zplug
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
else
	echo ".oh-my-zsh already found, skipping."
fi
