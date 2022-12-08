#!/usr/bin/env sh

if ! grep -Fxqs "executed_autostart" "$TMPFLAGS"; then

    mkdir -p "$XDG_HISTORY_DIR" # create history dir

    if sudo -n rfkill > /dev/null 2>&1; then
        [ -z "$AUTO_BT" ] && sudo rfkill block bluetooth
        [ -n "$NO_WIFI" ] && sudo rfkill block wifi
    fi

    [ -x "$(command -v fcitx)" ] && fcitx -d

    [ -n "$DISPLAY" ] && [ -x "command -v xsetroot" ] && xsetroot -solid "#000000" # set background

    echo "executed_autostart" >> "$TMPFLAGS"
fi
