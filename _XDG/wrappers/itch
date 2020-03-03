#!/usr/bin/env sh

PATH=$(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname $0)" | paste -sd:)
HOME="${XDG_FAKEHOME_DIR:-$HOME/.local/home}"
exec "$(basename $0)" "$@"
