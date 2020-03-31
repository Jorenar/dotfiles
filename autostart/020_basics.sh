#!/usr/bin/env sh

if [ -z "$EXECUTED_AUTOSTART" ]; then

    # turn off Bluetooth
    if sudo -n rfkill > /dev/null 2>&1; then
        sudo rfkill block bluetooth
    fi

    # set volume
    amixer -- set Master -60dB

    # start fcitx
    if [ -x "$(command -v fcitx)" ]; then
        fcitx -d
    fi

fi
