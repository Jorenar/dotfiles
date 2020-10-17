#!/usr/bin/env sh

if ! grep -Fxqs "executed_autostart" "$TMPFLAGS"; then

    # turn off Bluetooth
    if sudo -n rfkill > /dev/null 2>&1; then
        sudo rfkill block bluetooth
    fi

    # restore ALSA mixer state
    [ -f "$XDG_CONFIG_HOME/alsa/asound.state" ] && alsactl --file "$XDG_CONFIG_HOME/alsa/asound.state" restore

    # set volume
    amixer -- set Master -60dB

    # start fcitx
    [ -x "$(command -v fcitx)" ] && fcitx -d

    # start network
    if sudo -n netctl --help > /dev/null 2>&1; then
        [ -n "NETCTL_PROFILE" ] && sudo netctl start "$NETCTL_PROFILE"
    fi

    echo "executed_autostart" >> "$TMPFLAGS"
fi
