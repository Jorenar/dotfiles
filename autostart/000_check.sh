#!/usr/bin/env sh

if [ -f /tmp/executed_autostart ]; then
    export EXECUTED_AUTOSTART=true
else
    touch /tmp/executed_autostart
fi

if [ -n "$AUTO_STARTX" ] && [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] && [ ! -f /tmp/disable_auto_startx ]; then
    export AUTO_STARTX_CONFIRM=yes
elif [ -f /tmp/disable_auto_startx ]; then
    rm /tmp/disable_auto_startx
fi
