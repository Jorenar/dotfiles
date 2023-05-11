#!/usr/bin/env sh

#shellcheck disable=SC2089,SC2090,SC2155

wrapcmd="$1"
shift

if [ -z "$(command -v expect)" ]; then
    echo "expect not installed"
    exec $wrapcmd "$@"
fi

if [ "$wrapcmd" = "scp" ]; then
    host="$(echo "$@" | tr ' ' '\n' | grep : | cut -d: -f1)"
    conf="$(ssh -G "$host")"
else
    conf="$(ssh -G "$@")"
fi

get_var () {
    echo "$conf" | grep _SSHWRAP_"$1" | cut -d= -f2-
}

get_param () {
    echo "$conf" | awk '/^'"$1"' / { print $2 }'
}

prog="$(get_var PROG)"
[ -z "$prog" ] && prog="$wrapcmd"

hostname="$(get_param hostname)"
port="$(get_param port)"

pass_cmd="$(get_var PASS_CMD)"
pass_prompt="$(get_var PASS_PROMPT)"
[ -z "$pass_prompt" ] && pass_prompt="*assword: "

user="$(get_param user)"
user_prompt="$(get_var USER_PROMPT)"


expect_body=

if [ -n "$user" ] && [ -n "$user_prompt" ]; then
    expect_body="$expect_body
    expect $user_prompt
    send \"$user\\r\"
    "
fi

if [ -n "$pass_cmd" ]; then
    expect_body="$expect_body
        set pass [exec $pass_cmd]
        expect {
    "
    if [ "$prog" = "ssh" ] || [ "$prog" = "scp" ]; then
        expect_body="$expect_body
            \"Are you sure you want to continue connecting*?\" {
                send \"yes\r\"
                exp_continue
            }
        "
    fi
    expect_body="$expect_body
            \"$pass_prompt\" {
                send -- \"\$pass\"
                send -- \"\\r\"
            }
        }
    "
fi


case "$prog" in
    telnet)
        [ "$port" = "22" ] && echo "Warning: using default SSH port (22) for Telnet"
        args="$hostname $port"
        ;;
    *) args= ;;
esac

if [ -z "$expect_body" ]; then
    exec "$prog" ${args:-$@}
fi

exec expect -c "$(cat << EOF
    log_user 0
    spawn "$prog" ${args:-$@}
    $expect_body
    interact
EOF
)"
