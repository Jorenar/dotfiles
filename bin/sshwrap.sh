#!/usr/bin/env sh

#shellcheck disable=SC2089,SC2090,SC2155

wrapcmd="$1"
shift

if [ -z "$(command -v expect)" ]; then
    echo "expect not installed"
    exec $wrapcmd "$@"
fi

case "$wrapcmd" in
    scp|sshfs)
        host="$(echo "$@" | tr ' ' '\n' | grep : | cut -d: -f1)"
        conf="$(ssh -G "$host")"
        ;;
    *)
        conf="$(ssh -G "$@")"
        ;;
esac

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


args=
case "$prog" in
    sshfs)
        if [ -n "$pass_cmd" ]; then
            sh -c "$pass_cmd" | sshfs -o password_stdin "$@"
            exit
        fi
        ;;
    telnet)
        [ "$port" = "22" ] && echo "Warning: using default SSH port (22) for Telnet"
        args="$hostname $port"
        shift "$#"
        ;;
esac


gen_expect_body () {
    [ -n "$user" ] && [ -n "$user_prompt" ] && cat << EOB
        expect $user_prompt {
            send "$user\r"
        }
EOB

    [ -n "$pass_cmd" ] && cat << EOB
        set pass [exec $pass_cmd]
        expect {
EOB

    [ -n "$pass_cmd" ] && case "$prog" in
        ssh|scp|sshfs) cat << EOB
            "Are you sure you want to continue connecting*?" {
                send "yes\r"
                exp_continue
            }
EOB
        ;;
    esac

    [ -n "$pass_cmd" ] && cat << EOB
            "$pass_prompt" {
                send -- "\$pass"
                send -- "\r"
            }
        }
EOB
}

expect_body="$(gen_expect_body)"

if [ -z "$expect_body" ]; then
    # shellcheck disable=SC2086
    exec "$prog" $args "$@"
fi

expect_body="$(cat << EOB
    log_user 0
    spawn "$prog" $args $@
    $expect_body
    interact
EOB
)"

case "$0" in
    bash|ksh)
        # shellcheck disable=SC3038
        exec -a "$prog" expect -c "$expect_body"
        ;;
    *)
        exec expect -c "$expect_body"
        ;;
esac
