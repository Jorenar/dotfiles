#!/usr/bin/env sh

msg="$(cat)"

sendmail=
[ ! -x "$sendmail" ] && sendmail="$(command -v msmtp)"
[ ! -x "$sendmail" ] && sendmail="$(command -v sendmail)"
[ ! -x "$sendmail" ] && {
    1>&2 printf '%s: error: %s\n' \
        "$(basename "$0")" \
        'sendmail not found'
    exit 127
}

optsHdr="X-Sendmail-Cmd-Options"

opts="$(
    printf '%s' "$msg" | sed 's/\r$//' |\
        awk '/^'"$optsHdr"':/ { $1=""; printf $0 }'
)"
[ -n "$opts" ] && eval set -- "$opts" '"$@"'

printf '%s' "$msg" | grep -v '^'"$optsHdr"':' |\
    exec "$sendmail" --read-envelope-from -oi "$@"
