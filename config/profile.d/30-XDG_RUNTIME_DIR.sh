[   -z "$XDG_RUNTIME_DIR" ] && XDG_RUNTIME_DIR="/run/user/$(id -u)"
[ ! -d "$XDG_RUNTIME_DIR" ] && XDG_RUNTIME_DIR="$TMPDIR/$USER-runtime"

if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    mkdir -p -m 0700 "$XDG_RUNTIME_DIR" # ought to be '/tmp/user-runtime'
fi

if [ "$(find "$XDG_RUNTIME_DIR" -prune -printf '%m\n')" -ne 700 ]; then
    if ! chmod 0700 "$XDG_RUNTIME_DIR"; then
        echo "\$XDG_RUNTIME_DIR: permissions problem with $XDG_RUNTIME_DIR:" >&2
        ls -ld "$XDG_RUNTIME_DIR" >&2
        XDG_RUNTIME_DIR="$(mktemp -d "$TMPDIR/$USER"-runtime-XXXXXX)"
        chmod 0700 "$XDG_RUNTIME_DIR"
        echo "Setting XDG_RUNTIME_DIR to $XDG_RUNTIME_DIR" >&2
    fi
fi

export XDG_RUNTIME_DIR
