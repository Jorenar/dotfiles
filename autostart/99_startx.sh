#!/usr/bin/env sh

# Optimus manager
if grep -Fxq "switched_gpu" "$TMPFLAGS" && sudo -n prime-switch > /dev/null 2>&1; then
    sudo prime-switch
    sed -i '/switched_gpu/d' "$TMPFLAGS"
fi

# If there is no display and variable AUTOSTARTX is not empty then on tty1 start X
if [ -n "$AUTOSTARTX" ] && [ -z "$DISPLAY" ] && [ $XDG_VTNR -eq 1 ] && ! grep -Fxq "autostartedx" "$TMPFLAGS"; then

    echo "autostartedx" >> "$TMPFLAGS"

    sed -i '/GPU /d' "$TMPFLAGS"

    exec startX

elif grep -Fxq "autostartx=0" "$TMPFLAGS"; then
    sed -i '/autostartx=0/d' "$TMPFLAGS"
fi
