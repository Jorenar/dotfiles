#!/usr/bin/env sh

force=0
use_sudo=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        -f|--force) force=1 ;;
        --sudo) use_sudo=1 ;;
        *) ;;
    esac
    shift
done


[ -x "$(command -v git)" ] && \
    git submodule update --init --recursive --remote

. extern/pathmunge.sh/pathmunge.sh
. config/profile.d/30-variables.sh
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
        *) return 127 ;;
    esac
    case "$op" in
        s*)
            [ "$use_sudo" -eq 0 ] && return 1
            [ "$(id -u)" -ne 0 ] && sudo="sudo"
            ;;
    esac


    if [ "$force" -eq 1 ] && [ -e "$dest" ]; then
        old="$HOME/dotfiles.old/$dest"
        if mkdir -p "$(dirname "$old")"; then
            $sudo mv "$dest" "$old" && echo "Moved file '$dest' to directory '$old'"
        fi
    fi

    [ -e "$dest" ] && return 17
    $sudo mkdir -p "$(dirname "$dest")"
    $sudo sh -c "$action '$(abspath "$src")' '$dest'"
)


mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"


install  profile  %  "$HOME"/.profile

for c in config/*; do
    case "$c" in
        */dconf)
            install  "$c"  %  "$XDG_CONFIG_HOME"/dconf
            ;;
        */fail2ban)
            command -v fail2ban-server > /dev/null || continue
            for l in "$c"/*.local "$c"/*.d/*.local; do
                [ -e "$l" ] && install  "$l"  s%  /etc/fail2ban/"${l#"$c"/}"
            done
            ;;
        */firefox)
            t="$HOME/.local/opt/tor-browser/Browser/TorBrowser/Data/Browser/profile.default"
            for f in "$c"/*; do
                install  "$f"  @  "$XDG_DATA_HOME"/firefox/"${f##*/}"
                install  "$f"  @  "$t/${f##*/}"
            done
            ;;
        */gtk-3.0)
            install  "$c"/settings.ini  %  "$XDG_CONFIG_HOME"/gtk-3.0/settings.ini
            ;;
        */pacman.d)
            [ -x "$(command -v pacman)" ] || continue
            for h in "$c"/hooks/*; do
                install  "$h"  s%  /etc/pacman.d/hooks/"$(basename "$h")"
            done
            ;;
        */powershell)
            [ -n "$USERPROFILE" ] && \
                install "$c"  %  "$USERPROFILE"/Documents/WindowsPowerShell
            ;;
        */PowerToys)
            [ -n "$USERPROFILE" ] && \
                install "$c"  %  "$USERPROFILE"/AppData/Local/Microsoft/PowerToys
            ;;
        */sshd_config.d)
            for t in "$c"/*.conf; do
                f=/etc/ssh/sshd_config.d/"$(echo "${t##*/}" | sed "s/-USER-/-$(id -un)-/")"
                install  "$t"  s%  "$f"  &&  case "$t" in
                    *-USER-*) sudo sh -c 'sed "s/-#USER/$1/" "$2" > "$3"' - "$(id -un)" "$t" "$f" ;;
                esac
            done
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
            install  "$c"  %  "$XDG_CONFIG_HOME"/transmission-daemon/settings.json
            ;;
        */WindowsTerminal.json)
            ;;
        */WSL)
            [ -z "$WSL_DISTRO_NAME" ] && continue

            install  "$c"/wslconfig   %  "$USERPROFILE"/.wslconfig
            install  "$c"/wslgconfig  %  "$USERPROFILE"/.wslgconfig

            install  "$c"/wsl.conf  s%  /etc/wsl.conf
            ;;
        */misc)
            ;;
        *)
            install  "$c"  @  "$XDG_CONFIG_HOME"/"$(basename "$c")"
            ;;
    esac
done

for s in share/*; do
    case "$s" in
        */applications)
            for a in "$s"/*; do
                install  "$a"  @  "$XDG_DATA_HOME"/applications/"$(basename "$a")"
            done
            ;;
        *)
            install  "$s"  @  "$XDG_DATA_HOME"/"$(basename "$s")"
            ;;
    esac
done

install  templates/  @  "$XDG_TEMPLATES_DIR"

chmod -R -w \
    config/htop/htoprc \
    config/mimeapps.list \
    config/OpenSCAD/OpenSCAD.conf \
    config/qt5ct

xdg_wrapper.sh --install
