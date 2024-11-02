#!/usr/bin/env sh

for inbox in "$HOME"/.local/var/mail/*/INBOX; do
    [ ! -d "$inbox" ] && continue
    find "$inbox" -type f -not \( -name '*S' -o -name '.*' \) | wc -l
done | paste -sd "," -

# awk '/^Path / { print $2 }' "$XDG_CONFIG_HOME"/isyncrc | while read -r dir; do
#     eval dir="$dir"
#     find "$dir"/INBOX -type f -not \( -name '*S' -o -name '.*' \) | wc -l
# done | paste -sd "," -
