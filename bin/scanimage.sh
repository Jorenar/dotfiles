#!/usr/bin/env sh

[ ! -x "$(command -v scanimage)" ] && exit 1

scanimage \
    --progress \
    --format=jpeg \
    --mode=Color \
    --resolution=300 \
    "$@"
