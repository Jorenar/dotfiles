#!/usr/bin/env sh

# If there's no display and variable NOAUTOSTARTX is empty then on tty1 start X
if [ -z "$NOAUTOSTARTX" ] && [ -z "$WSL_DISTRO_NAME" ] && \
        [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]
then
    for x in "${TMPDIR:-/tmp}"/.X11-*; do
        [ ! -d "$x" ] && exec startX
        break
    done
fi
