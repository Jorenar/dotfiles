#!/usr/bin/env sh

if sudo -n rfkill &> /dev/null; then
    sudo rfkill block bluetooth
fi
