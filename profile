# ~/.profile

for p in "$HOME"/.local/config/profile.d/*.sh; do . "$p"; done
export SHELL="$(command -v myshell.sh)"
# ------------------------------------------------------------

[ "$(tty)" != "/dev/tty1" ] && case "$-" in
    *i*) [ -x "$SHELL" ] && exec "$SHELL" ;;
esac
