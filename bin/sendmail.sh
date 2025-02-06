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


case "$sendmail" in
    */msmtp) set -- "--read-envelope-from" "$@" ;;
esac

from="$(
    for o in "$@"; do
        case "$o" in
            -a|-f|--from|--from=*) return ;;
            --read-envelope-from) return ;;
            --*) ;;
            -*a*|-*f*) return ;;
        esac
    done

    echo "$msg" | grep -m 1 '^From:\s' | awk -v RS="[<>]" '/@/'
)"
[ -n "$from" ] && set -- "-f" "$from" "$@"

printf '%s' "$msg" | grep -v '^'"$optsHdr"':' |\
    exec "$sendmail" -oi "$@"
