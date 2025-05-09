if ! type pathmunge 2> /dev/null | grep -q 'function'; then
    . "$XDG_CONFIG_HOME"/profile.d/10-pathmunge.sh || return 1
fi

if [ -n "$WSL_DISTRO_NAME" ]; then
    pathmunge "/mnt/c/Windows/System32"
    pathmunge "/mnt/c/Windows/System32/Wbem"
    pathmunge "/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
    [ -n "$USERPROFILE" ] && \
        pathmunge "$USERPROFILE/AppData/Local/Microsoft/WindowsApps"
fi

pathmunge "/usr/lib/ccache"
pathmunge "/usr/lib/ccache/bin"

for opt in "$HOME"/.local/opt/*/bin; do
    [ -d "$opt" ] && pathmunge "$opt"
done

for opt in "$HOME"/.local/opt/*/*/bin; do
    [ -d "$opt"/../../bin ] && continue
    [ -d "$opt" ] && pathmunge "$opt"
done

pathmunge "$HOME"/.local/bin
