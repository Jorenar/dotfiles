#!/usr/bin/env sh

if [ -n "$AUTO_STARTX_CONFIRM" ]; then
    if sudo -n /usr/bin/prime-switch &> /dev/null; then
        sudo prime-switch
        prime-offload
    fi
fi
