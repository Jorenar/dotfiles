#!/usr/bin/env sh
# shellcheck disable=SC2013

trap 'exit 1' INT

for host in $(sed -n -E 's/^\s*Host\s+(\S+).*/\1/ip' "$1" | grep -v '\*'); do
    printf '%s' "$host"

    hostname="$(ssh -G "$host" | grep '^hostname' | cut -d' ' -f2)"

    for knownsfile in $(ssh -G "$host" | grep userknownhost | cut -d' ' -f2-); do
        [ -f "$knownsfile" ] && ssh-keygen -f "$knownsfile" -R "$hostname" > /dev/null 2>&1
    done

    exp="$(cat << EOF
set pass [exec pass $2]
spawn "ssh-copy-id" "-f" "-o" "ConnectTimeout=5" "$host"
expect {
    "Are you sure you want to continue connecting*?" {
        send "yes\r"
        exp_continue
    }
    "password:" {
        send "\$pass\r"
    }
    eof
}
lassign [wait] pid spawnid os_error_flag value

if {\$os_error_flag == 0} {
    puts "exit status: \$value"
} else {
    puts "errno: \$value"
}
EOF
    )"

    ret_text="$(expect -c "$exp")"

    if echo "$ret_text" | grep -q 'Number of key(s) added: 1'; then
        printf ' [added]'
    elif echo "$ret_text" | grep -q 'exit status: 1'; then
        printf " [timeouted]"
    else
        echo "$ret_text" | sed 's/^/ >> /'
    fi

    printf '\n'
done
