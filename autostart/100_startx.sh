#!/usr/bin/env sh

# If there is no display and variable AUTOSTARTX is not empty then on tty1 start X

if [ -n "$AUTOSTARTX" ] && [ -z "$DISPLAY" ] && [ $XDG_VTNR -eq 1 ] && [ ! -f "${TMPDIR:-/tmp}/disable_autostartx" ]; then

    # Optimus manager
    if sudo -n /usr/bin/prime-switch > /dev/null 2>&1; then
        sudo prime-switch
        prime-offload
    fi

    exec startX

elif [ -f "${TMPDIR:-/tmp}/disable_autostartx" ]; then
    rm "${TMPDIR:-/tmp}/disable_autostartx"
fi
