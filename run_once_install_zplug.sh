#!/bin/bash

if [ ! -d "$ZPLUG_HOME" ] || [ -z "$(ls -A "$ZPLUG_HOME" 2>/dev/null)" ]; then
	export ZPLUG_HOME=/$HOME/.zplug
	ZPLUG_HOME=$HOME/.zplug
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi
