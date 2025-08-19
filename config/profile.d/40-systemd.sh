command -v systemctl > /dev/null || return

(
    for e in "$XDG_CONFIG_HOME"/environment.d/*.conf; do
        [ -s "$e" ] && . "$e"
    done; unset e
    systemctl --user import-environment $(env | cut -d= -f1)
)

if [ "${UNLINK_DOT_CONFIG:-1}" -ne 0 ] \
        && [ -L "$HOME"/.config ] \
        && [ "$XDG_CONFIG_HOME" != "$HOME"/.config ] \
        && [ ! -e "$XDG_RUNTIME_DIR"/systemd/user ]
then
    ln -s "$XDG_CONFIG_HOME"/systemd/user "$XDG_RUNTIME_DIR"/systemd/
    rm "$HOME"/.config
    systemctl --user daemon-reload
    systemctl --user start ln-dotconfig
fi
