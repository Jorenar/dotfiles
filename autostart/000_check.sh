#!/usr/bin/env sh

if [ -f "${TMPDIR:-/tmp}/executed_autostart" ]; then
    export EXECUTED_AUTOSTART=true
else
    touch "${TMPDIR:-/tmp}/executed_autostart"
fi
