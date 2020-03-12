#!/usr/bin/env sh

# If there is no display and variable AUTOSTARTX is set then on tty1 start X
if [ -z "${AUTOSTARTX+x}" ] && [ -z $DISPLAY ] && [ $XDG_VTNR -eq 1 ] && [ ! -f "${TMPDIR:-/tmp}/disable_autostartx" ]; then

    # Optimus manager
    if sudo -n /usr/bin/prime-switch > /dev/null 2>&1; then
        sudo prime-switch
        prime-offload
    fi

    d=0
    while [ -e "/tmp/.X$d-lock" -o -S "/tmp/.X11-unix/X$d" ]; do
        d=$(($d + 1))
    done

    exec xinit -- :"$d" vt"$XDG_VTNR"; unset d

elif [ -f "${TMPDIR:-/tmp}/disable_autostartx" ]; then
    rm "${TMPDIR:-/tmp}/disable_autostartx"
fi
