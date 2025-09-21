#!/usr/bin/env sh

escape () {
    case "$1" in
        *' '*|*"'"*|*'"'*) ;;
        *) printf '%s ' "$1"; return ;;
    esac
    printf "'%s' " "$(printf '%s' "$1" | sed -e "s/'/'\\\\''/g")"
}

mdir=

while read -r m; do
    mdir="$(echo "$m" | cut -d' ' -f3)"
    case "$PWD" in
        "$mdir"*) ;;
        *) continue ;;
    esac
    temp="${m%% *}"
    host="${temp%%:*}"
    hdir="${temp#*:}"
    hdir="${hdir:-~}"
    break
done << EOF
$(mount | grep 'fuse.sshfs')
EOF

if [ -z "$host" ]; then
    echo "No SSHFS mount found in current directory." >&2
    exit 1
fi

pwd="${PWD#"$mdir"}"
hdir="${hdir%/}/${pwd#/}"

exec ssh "$host" "cd $(escape "$hdir") && $(for arg in "$@"; do
    escape "$arg"
done)"
