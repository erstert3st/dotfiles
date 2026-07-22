#!/bin/bash
# Todo: get rid of oh-my-zsh eventually (zplug covers most of it)
set -euo pipefail

if [ ! -f "$HOME/.zplug/init.zsh" ]; then
	echo "Installing zplug..."
	rm -rf "$HOME/.zplug"
	git clone --depth 1 https://github.com/zplug/zplug "$HOME/.zplug"
else
	echo "zplug already installed, skipping."
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "Getting ohmyz.sh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc --skip-chsh
else
	echo ".oh-my-zsh already found, skipping."
fi
