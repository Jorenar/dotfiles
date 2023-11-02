#!/usr/bin/env sh


[ "$1" = "-f" ] && gf_force=1 || gf_force=0

# helpers {{{

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

# }}}


cd "$(dirname "$(abspath "$0")")" || exit 1

. env/variables
. env/user-dirs.dirs


install () (
    src="$(abspath "$1")"
    op="$2"
    dest="$3"
    mode="$4"

    action=
    case "$op" in
        '@') action="ln -sf" ;;
        '>') action="cp -r" ;;
        *) return ;;
    esac


    if [ "$gf_force" -eq 1 ] && [ -e "$dest" ]; then
        if mkdir -p "$HOME/dotfiles.old/"; then
            mv "$dest" "$HOME/dotfiles.old/" && \
                echo "Moved file '$dest' to directory '$HOME/dotfiles.old/'"
        fi
    fi

    if [ ! -e "$dest" ]; then
        mkdir -p "$(dirname "$dest")"
        sh -c "$action '$src' '$dest'"

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



install  env/profile  >  "$HOME"/.profile
install  templates/   @  "$XDG_TEMPLATES_DIR"

install_bulk "$XDG_CONFIG_HOME" << EOL

    aerc/               @  aerc
    asoundrc            @  alsa/asoundrc
    bash/               @  bash
    ccache.config       @  ccache/config
    chktexrc            @  .chktexrc
    commafeed.yml       @  commafeed.yml
    ctags/              @  ctags
    deno.json           @  deno.json
    dosbox.conf         @  dosbox/dosbox.conf
    env                 @  env
    env/mimeapps.list   @  mimeapps.list
    env/user-dirs.dirs  @  user-dirs.dirs
    feh/                @  feh
    fish/               @  fish
    fonts.conf          @  fontconfig/fonts.conf
    gdbinit             @  gdb/gdbinit
    git/                @  git
    grip.py             @  grip/grip.py
    gtkrc-2.0           @  gtk-2.0/gtkrc
    htoprc              @  htop/htoprc                          -w
    i3/                 @  i3
    inputrc             @  readline/inputrc
    lesskey             @  lesskey
    mailcap             @  mailcap
    mpv/                @  mpv
    muttrc              @  mutt/muttrc
    myclirc             @  mycli/myclirc
    newsboat            @  newsboat/config
    npmrc               @  npm/npmrc
    OpenSCAD.conf       @  OpenSCAD/OpenSCAD.conf               -w
    pavucontrol.ini     >  pavucontrol.ini
    polybar             @  polybar/config
    python_config.py    @  python/config.py
    QuiteRss.ini        >  QuiteRss/QuiteRss.ini
    ranger.conf         @  ranger/rc.conf
    Renviron            @  R/Renviron
    sh/                 @  sh
    shellcheckrc        @  shellcheckrc
    spicy_settings      @  spicy/settings
    sqliterc            @  sqlite3/sqliterc
    ssh_config          @  ssh/config
    ssr.conf            >  simplescreenrecorder/settings.conf
    stalonetrayrc       @  stalonetrayrc
    telnetrc            @  .telnetrc
    tigrc               @  tig/config
    tmux/               @  tmux
    transmission.json   >  transmission-daemon/settings.json
    uncrustify/         @  uncrustify
    vim/                @  vim
    weechat/            @  weechat                              -w
    X11/                @  X11
    zathurarc           @  zathura/zathurarc
    zsh                 @  zsh

EOL

install_bulk "$XDG_DATA_HOME" << EOL

    app.desktop.d/           @  applications/custom
    firefox/user.js          @  firefox/user.js
    firefox/userChrome.css   @  firefox/chrome/userChrome.css
    firefox/userContent.css  @  firefox/chrome/userContent.css
    fonts/                   @  fonts
    themes/                  @  themes

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
