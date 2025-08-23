#!/bin/bash

if [ ! -d "$ZPLUG_HOME" ] || [ -z "$(ls -A "$ZPLUG_HOME" 2>/dev/null)" ]; then
	export ZPLUG_HOME=/$HOME/.zplug
	ZPLUG_HOME=$HOME/.zplug
	rm -rf "$ZPLUG_HOME"
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
else
	echo "Zplug is already installed."
fi
