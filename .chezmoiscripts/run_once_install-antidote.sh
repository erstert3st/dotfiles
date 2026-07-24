#!/bin/bash
set -euo pipefail

if [ ! -d "$HOME/.antidote" ]; then
	echo "Installing antidote..."
	git clone --depth 1 https://github.com/mattmc3/antidote "$HOME/.antidote"
else
	echo "antidote already installed, skipping."
fi
