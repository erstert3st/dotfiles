#!/bin/bash

if [ -x "$(command -v getnf)" ]; then
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash -s -- --silent
fi
