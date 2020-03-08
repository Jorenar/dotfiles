#!/usr/bin/env sh

# If there is display and variable AUTO_STARTX is set then on tty1 `startx`
if [ -n "$AUTO_STARTX" ] && [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] && [ ! -f /tmp/disable_auto_startx ]; then

    # Optimus manager
    if sudo -n /usr/bin/prime-switch > /dev/null 2>&1; then
        sudo prime-switch
        prime-offload
    fi

    exec startx $XINITRC

elif [ -f /tmp/disable_auto_startx ]; then
    rm /tmp/disable_auto_startx
fi
