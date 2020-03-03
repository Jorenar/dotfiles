#!/usr/bin/env sh

if [ -f /tmp/executed_autostart ]; then
    export EXECUTED_AUTOSTART=true
else
    touch /tmp/executed_autostart
fi
