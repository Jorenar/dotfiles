init_gpg_agent () (
    if [ ! -x "$(command -v gpg-agent)" ]; then
        return
    fi

    gpg_id="${PASSWORD_STORE_DIR:-"$HOME"/.password-store}"/.gpg-id
    [ ! -s "$gpg_id" ] && return
    key="$(cat "$gpg_id")"

    tmp="${TMPDIR:-/tmp}/gpg.dummy.$$"

    echo | gpg --encrypt --recipient "$key" > "$tmp" 2> /dev/null
    gpg --decrypt "$tmp" > /dev/null 2>&1

    rm "$tmp"
)
