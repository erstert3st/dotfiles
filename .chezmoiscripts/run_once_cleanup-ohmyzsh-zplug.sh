#!/bin/bash
# One-time cleanup after the oh-my-zsh/zplug -> antidote migration.
set -euo pipefail

for dir in "$HOME/.oh-my-zsh" "$HOME/.zplug"; do
	if [ -d "$dir" ]; then
		echo "Removing $dir"
		rm -rf "$dir"
	fi
done

rm -f "$HOME"/.zcompdump*
