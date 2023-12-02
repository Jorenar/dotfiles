#!/usr/bin/env sh


[ "$1" = "-f" ] && gf_force=1 || gf_force=0

if [ -x "$(command -v git)" ]; then
    echo "Updating Git submodules"
    git submodule update --init --recursive --remote
fi

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
    mode="$4"

    action=
    case "$op" in
        '@') action="ln -sf" ;;
        '%') action="cp -r" ;;
        *) return ;;
    esac


    if [ "$gf_force" -eq 1 ] && [ -e "$dest" ]; then
        old="$HOME/dotfiles.old/$dest"
        if mkdir -p "$(dirname "$old")"; then
            mv "$dest" "$old" && echo "Moved file '$dest' to directory '$old'"
        fi
    fi

    if [ ! -e "$dest" ]; then
        mkdir -p "$(dirname "$dest")"
        sh -c "$action '$(abspath "$src")' '$dest'"

        [ -n "$mode" ] && chmod "$mode" "$dest"
    fi
)

install_bulk () (
    prefix="$1"
    fmt="%s %s $prefix/%s %s"

    while read -r line; do
        # shellcheck disable=SC2059,SC2086
        [ -n "$line" ] && install $(printf "$fmt" $line)
    done
)


[ ! -s "$HOME"/.profile ] && cat > "$HOME"/.profile << 'EOF'
# ~/.profile

for profile in "$HOME"/.local/config/profile.d/*.sh; do
    . "$profile"
done

export SHELL="$(command -v myshell.sh)"

# ------------------------------------------------------------------------------
EOF


if [ "$XDG_CONFIG_HOME" != "$HOME"/.config ]; then
    mkdir -p "$XDG_CONFIG_HOME"
    install  "$XDG_CONFIG_HOME"  @  "$HOME"/.config
fi

install  templates/  @  "$XDG_TEMPLATES_DIR"

install_bulk "$XDG_CONFIG_HOME" << EOL

    config/aerc/               @  aerc
    config/asciinema/          @  asciinema
    config/bash/               @  bash
    config/ccache.config       @  ccache/config
    config/chktexrc            @  .chktexrc
    config/commafeed.yml       @  commafeed.yml
    config/ctags/              @  ctags
    config/deno.json           @  deno.json
    config/dosbox.conf         @  dosbox/dosbox.conf
    config/feh/                @  feh
    config/fonts.conf          @  fontconfig/fonts.conf
    config/gdbinit             @  gdb/gdbinit
    config/git/                @  git
    config/gtk3-settings.ini   @  gtk-3.0/settings.ini
    config/htoprc              @  htop/htoprc                          -w
    config/i3/                 @  i3
    config/inputrc             @  readline/inputrc
    config/lesskey             @  lesskey
    config/mimeapps.list       @  mimeapps.list
    config/mpv/                @  mpv
    config/muttrc              @  mutt/muttrc
    config/newsboat            @  newsboat/config
    config/OpenSCAD.conf       @  OpenSCAD/OpenSCAD.conf               -w
    config/profile.d           @  profile.d
    config/python_config.py    @  python/config.py
    config/ranger.conf         @  ranger/rc.conf
    config/sh/                 @  sh
    config/shellcheckrc        @  shellcheckrc
    config/spicy_settings      @  spicy/settings
    config/sqliterc            @  sqlite3/sqliterc
    config/ssh_config          @  ssh/config
    config/ssr.conf            %  simplescreenrecorder/settings.conf
    config/stalonetrayrc       @  stalonetrayrc
    config/telnetrc            @  .telnetrc
    config/tigrc               @  tig/config
    config/tmux/               @  tmux
    config/transmission.json   %  transmission-daemon/settings.json
    config/uncrustify/         @  uncrustify
    config/user-dirs.conf      @  user-dirs.conf
    config/user-dirs.dirs      @  user-dirs.dirs
    config/vim/                @  vim
    config/weechat/            @  weechat                              -w
    config/X11/                @  X11
    config/zathurarc           @  zathura/zathurarc
    config/zsh                 @  zsh

EOL

install_bulk "$XDG_DATA_HOME" << EOL

    config/firefox/user.js          @  firefox/user.js
    config/firefox/userChrome.css   @  firefox/chrome/userChrome.css
    config/firefox/userContent.css  @  firefox/chrome/userContent.css

    misc/desktop_entries/  @  applications/custom

    fonts/  @  fonts

EOL


# xdg_wrapper.sh {{{
sed -n -e 's/^#~ //p' "bin/xdg_wrapper.sh" | while IFS= read -r exe; do
    if [ -x "$(command -v "$exe")" ]; then
        install  bin/xdg_wrapper.sh  @  "$HOME/.local/opt/xdg.wrappers/bin/$exe"
    fi
done
# }}}

# DCONF_PROFILE {{{
#   prevents creation of ~/.dconf
DCONF_PROFILE="$XDG_CONFIG_HOME/dconf/user"
mkdir -p "$(dirname "$DCONF_PROFILE")" && \
    touch "$DCONF_PROFILE"
# }}}

mkdir -p "$HISTORY_DIR"
mkdir -p "$XDG_DATA_HOME"/alsa
