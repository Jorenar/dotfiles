#!/usr/bin/env sh

# Init {{{1

force_flag=$1
DIR="$(dirname "$(realpath "$0")")"

. "$DIR"/env/variables; . "$DIR"/env/user-dirs.dirs

# 1nd argument - file in dotfiles dir
# 2rd argument - location of link
# 3th argument - permissions
linking() {

    if [ "$force_flag" = "-f" ] && [ -e "$2" ]; then
        mkdir -p "$HOME/dotfiles.old/"
        mv "$2" "$HOME/dotfiles.old/"
        echo "Moved file $2 to directory $HOME/dotfiles.old/"
    fi

    if [ ! -e "$2" ]; then
        mkdir -p "$(dirname "$2")"
        if [ "$3" = "CP" ]; then
            cp -r "$DIR/$1" "$2"
            mod="$4"
        else
            ln -sf "$DIR/$1" "$2"
            mod="$3"
        fi
    fi

    [ -n "$mod" ] && chmod "$mod" "$2"

}

# 1nd argument - prefix
# 2rd argument - list
linking_() {
    echo "$2" | while IFS= read -r line; do
        [ -n "$line" ] && linking $(echo "$line" | sed "s,@\s*,$1/,")
    done
}

# MAIN {{{1

linking_ "$XDG_CONFIG_HOME" '

    aerc/               @  aerc
    asoundrc            @  alsa/asoundrc
    bash/               @  bash
    ccache.config       @  ccache/config
    chktexrc            @  .chktexrc
    commafeed.yml       @  commafeed.yml
    cshrc               @  csh/.cshrc
    ctags/              @  ctags
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
    pavucontrol.ini     @  pavucontrol.ini                      CP
    polybar             @  polybar/config
    python_config.py    @  python/config.py
    QuiteRss.ini        @  QuiteRss/QuiteRss.ini                CP
    ranger.conf         @  ranger/rc.conf
    Renviron            @  R/Renviron
    shell/              @  shell
    spicy_settings      @  spicy/settings
    sqliterc            @  sqlite3/sqliterc
    ssh_config          @  ssh/config
    ssr.conf            @  simplescreenrecorder/settings.conf   CP
    stalonetrayrc       @  stalonetrayrc
    tigrc               @  tig/config
    tmux/               @  tmux
    transmission.json   @  transmission-daemon/settings.json    CP
    uncrustify/         @  uncrustify
    vim/                @  vim
    weechat/            @  weechat                              -w
    X11/                @  X11
    zathurarc           @  zathura/zathurarc
    zshrc               @  zsh/.zshrc

'

linking_ "$XDG_DATA_HOME" '

    app.desktop.d/           @  applications/custom
    firefox/user.js          @  firefox/user.js
    firefox/userChrome.css   @  firefox/chrome/userChrome.css
    firefox/userContent.css  @  firefox/chrome/userContent.css
    fonts/                   @  fonts
    themes/                  @  themes

'

linking  bin/         $HOME/.local/bin/scripts
linking  templates/   $XDG_TEMPLATES_DIR

# "PATCHING" {{{1

patch_dir="$HOME/.local/bin/_patch"
find "$patch_dir" -type l -delete # clean old symlinks to wrappers

prompt_sudo="$(sudo -nv 2>&1)"
if [ $? -eq 0 ] || echo "$prompt_sudo" | grep -q '^sudo: a password'; then
    hasSudo=1
fi

# xdg_wrapper.sh {{{2
sed -n -e 's/^#~ //p' "$DIR/_patch/xdg_wrapper.sh" | while IFS= read -r exe; do
    exe="$(echo $exe | cut -f1 -d'#')"
    [ -x "$(command -v $exe)" ] && linking  _patch/xdg_wrapper.sh  $patch_dir/xdg/$exe
done
chmod u+x $DIR/_patch/xdg_wrapper.sh

# /etc/profile.d/xdg_profile.sh {{{2
if [ -n "$hasSudo" ] && [ ! -f /etc/profile.d/xdg_profile.sh ]; then
    printf "Install root patches for XDG support for 'profile' file? [y/N] "
    read -r REPLY
    if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
        sudo install -Dm644 $DIR/_patch/xdg_profile.sh /etc/profile.d/xdg_profile.sh
    fi
fi
[ ! -f /etc/profile.d/xdg_profile.sh ] && linking  env/profile  $HOME/.profile

# pam_environment {{{2
if [ -n "$hasSudo" ] && ! grep -q "XDG_CONFIG_HOME" /etc/security/pam_env.conf; then
    printf 'Append XDG variables to /etc/security/pam_env.conf? [y/N] '
    read -r REPLY
    if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
        sudo tee -a /etc/security/pam_env.conf < $DIR/env/pam > /dev/null
    fi
fi
grep -q "XDG_CONFIG_HOME" /etc/security/pam_env.conf || linking  env/pam  $HOME/.pam_environment

# ssh_autopass.sh {{{2
linking  _patch/ssh_autopass.sh  $patch_dir/ssh

# ~ {{{2

mkdir -p "$(dirname $DCONF_PROFILE)" && touch "$DCONF_PROFILE" # prevents creating ~/.dconf
mkdir -p $XDG_DATA_HOME/alsa
