#!/usr/bin/env sh

awk '/^Path / { print $2 }' "$XDG_CONFIG_HOME"/isyncrc | while read -r dir; do
    eval dir="$dir"
    find "$dir"/INBOX -type f -not \( -name '*S' -o -name '.*' \) | wc -l
done | paste -sd "," -
