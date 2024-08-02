#!/usr/bin/env sh

# Helper downloading the latest pre-built binary of Vale
# (useful on distributions that don't have it in repos)

ver="$(curl https://api.github.com/repos/errata-ai/vale/releases/latest | jq -r '.tag_name' | tr -d 'v')"
curl -OL "https://github.com/errata-ai/vale/releases/download/v${ver}/vale_${ver}_Linux_64-bit.tar.gz"
mkdir -p "$HOME"/.local/bin
tar -xzf vale_"${ver}"_*.tar.gz -C "$HOME"/.local/bin vale
rm vale_"${ver}"_*.tar.gz
vale sync
