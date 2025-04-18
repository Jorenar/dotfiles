#!/usr/bin/env sh


gf_force=0
gf_sudo=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        -f|--force) gf_force=1 ;;
        --sudo) gf_sudo=1 ;;
        *) ;;
    esac
    shift
done


[ -x "$(command -v git)" ] && \
    git submodule update --init --recursive --remote

. extern/pathmunge.sh/pathmunge.sh
. config/profile.d/20-variables.sh
. config/user-dirs.dirs


abspath () (
    if [ -d "$1" ]; then
        cd "$1" && pwd
    elif [ -f "$1" ]; then
        case "$1" in
            /*)  echo "$1" ;;
            */*) echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")" ;;
            *)   echo "$PWD/$1" ;;
        esac
    else
        >&2 echo "abspath() is unable to operate on not exisiting paths"
    fi
)

install () (
    src="$1"
    op="$2"
    dest="$3"

    sudo=
    action=
    case "$op" in
        *@) action='ln -sf' ;;
        *%) action='cp -r' ;;
        *) return ;;
    esac
    case "$op" in
        s*)
            [ "$gf_sudo" -eq 0 ] && return
            [ "$(id -u)" -ne 0 ] && sudo="sudo"
            ;;
    esac


    if [ "$gf_force" -eq 1 ] && [ -e "$dest" ]; then
        old="$HOME/dotfiles.old/$dest"
        if mkdir -p "$(dirname "$old")"; then
            $sudo mv "$dest" "$old" && echo "Moved file '$dest' to directory '$old'"
        fi
    fi

    if [ ! -e "$dest" ]; then
        $sudo mkdir -p "$(dirname "$dest")"
        $sudo sh -c "$action '$(abspath "$src")' '$dest'"
    fi
)


[ ! -s "$HOME"/.profile ] && cat > "$HOME"/.profile << 'EOF'
for p in "$HOME"/.local/config/profile.d/*.sh; do . "$p"; done
export SHELL="$(command -v myshell.sh)"
# ------------------------------------------------------------
EOF


if [ "$XDG_CONFIG_HOME" != "$HOME"/.config ]; then
    mkdir -p "$XDG_CONFIG_HOME"
    install  "$XDG_CONFIG_HOME"  @  "$HOME"/.config
fi


for c in config/*; do
    case "$c" in
        */firefox)
            for f in "$c"/*; do
                install  "$f"  @  "$XDG_DATA_HOME"/firefox/"$(basename "$f")"
            done
            ;;
        */gtk-3.0)
            install  "$c"/settings.ini  @  "$XDG_CONFIG_HOME"/gtk-3.0/settings.ini
            ;;
        */powershell)
            [ -n "$USERPROFILE" ] && \
                install "$c"  %  "$USERPROFILE"/Documents/WindowsPowerShell
            ;;
        */PowerToys)
            [ -n "$USERPROFILE" ] && \
                install "$c"  %  "$USERPROFILE"/AppData/Local/Microsoft/PowerToys
            ;;
        */sudoers.d)
            for t in "$c"/*; do
                install  "$t"  s%  /etc/sudoers.d/"$(basename "$t")"
            done
            ;;
        */tmpfiles.d)
            for t in "$c"/*; do
                case "$t" in
                    *wsl*) [ -z "$WSL_DISTRO_NAME" ] && continue ;;
                esac
                install  "$t"  s%  /etc/tmpfiles.d/"$(basename "$t")"
            done
            ;;
        */transmission.json)
            install  config/transmission.json  %  "$XDG_CONFIG_HOME"/transmission-daemon/settings.json
            ;;
        */WindowsTerminal.json)
            ;;
        */WSL)
            [ -z "$WSL_DISTRO_NAME" ] && continue

            install  "$c"/wslconfig   %  "$USERPROFILE"/.wslconfig
            install  "$c"/wslgconfig  %  "$USERPROFILE"/.wslgconfig

            install  "$c"/wsl.conf  s%  /etc/wsl.conf
            ;;
        *)
            install  "$c"  @  "$XDG_CONFIG_HOME"/"$(basename "$c")"
            ;;
    esac
done

install  extern/klipmenu/       @  "$HOME"/.local/opt/klipmenu
install  fonts/                 @  "$XDG_DATA_HOME"/fonts
install  misc/desktop_entries/  @  "$XDG_DATA_HOME"/applications/custom
install  templates/             @  "$XDG_TEMPLATES_DIR"

xdg_wrapper.sh --install

chmod -R -w \
    config/htop/htoprc \
    config/OpenSCAD/OpenSCAD.conf \
    config/qt5ct

# prevents creation of ~/.dconf:
sh -c 'mkdir -p "$1" && touch "$1"/user' - "$XDG_CONFIG_HOME/dconf"
