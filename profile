# ~/.profile

for p in "$HOME"/.local/config/profile.d/*.sh; do . "$p"; done
export SHELL="$(command -v myshell.sh)"
# ------------------------------------------------------------

# export FOO=...

[ "$(tty)" != "/dev/tty1" ] && case "$-" in
    *i*) [ -x "$SHELL" ] && exec "$SHELL" ;;
esac

# systemctl --user start ...
# init-gpg-agent.sh
