#!/usr/bin/env sh

HOME="${XDG_FAKEHOME_DIR:-$HOME/.local/fakehome}"

for dir in $(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname $0)"); do
    [ -x "$dir/$(basename $0)" ] && exec "$dir/$(basename $0)" "$@"
done
