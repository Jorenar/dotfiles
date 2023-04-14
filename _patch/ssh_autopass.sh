#!/usr/bin/env sh

#shellcheck disable=SC2089,SC2090,SC2155

# Remove directory with wrapper from PATH (to prevent cyclical execution)
PATH="$(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname $0)" | paste -sd:)"

conf="$(ssh -G "$@")"

pass_cmd="$(echo "$conf" | grep _SSHPASS_CMD | cut -d= -f2-)"

if [ -n "$pass_cmd" ]; then
    export SSHPASS="$($pass_cmd)"

    sshpass="sshpass -e"

    prompt="$(echo "$conf" | grep _SSHPASS_PROMPT | cut -d= -f2-)"
    if [ -n "$prompt" ]; then
        sshpass="$sshpass -P '$prompt'"
    fi
fi

exec $sshpass ssh "$@"
