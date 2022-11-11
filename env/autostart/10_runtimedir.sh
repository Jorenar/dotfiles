#!/usr/bin/env sh

if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    mkdir -p -m 0700 "$XDG_RUNTIME_DIR" # ought to be '/tmp/user-runtime'
fi

if [ "$(stat -c '%a' "$XDG_RUNTIME_DIR")" != 700 ]; then
    echo "\$XDG_RUNTIME_DIR: permissions problem with $XDG_RUNTIME_DIR:" >&2
    ls -ld "$XDG_RUNTIME_DIR" >&2
    export XDG_RUNTIME_DIR="$(mktemp -d "$TMPDIR/$USER"-runtime-XXXXXX)"
    echo "Set \$XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" >&2
fi
