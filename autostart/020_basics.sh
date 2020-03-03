#!/usr/bin/env sh

if [ -z "$EXECUTED_AUTOSTART" ]; then

    # turn off Bluetooth
    if sudo -n rfkill &> /dev/null; then
        sudo rfkill block bluetooth
    fi

    # disable touchpad
    xinput disable "$(xinput list | grep -io 'touchpad.*id=[0-9]*' | sed 's/^.*id=//')"

    # set volume
    amixer -- set Master -60dB

    # start fcitx
    if which fcitx; then
        fcitx -d
    fi

fi
