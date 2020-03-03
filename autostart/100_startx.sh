#!/usr/bin/env sh

if [ -n "$AUTO_STARTX_CONFIRM" ]; then
    exec startx $XINITRC
    unset AUTO_STARTX_CONFIRM
fi
