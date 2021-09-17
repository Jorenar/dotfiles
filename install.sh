#!/usr/bin/env sh

# Init {{{1

force_flag=$1
DIR="$(dirname $(realpath $0))"

. $DIR/env/variables; . $DIR/env/user-dirs.dirs

chmod -R +x bin/

# 1nd argument - file in dotfiles dir
# 2rd argument - location of link
# 3th argument - permissions
linking() {

    if [ "$force_flag" = "-f" ] && [ -e "$2" ]; then
        mkdir -p $HOME/dotfiles.old/
        mv "$2" "$HOME/dotfiles.old/"
        echo "Moved file $2 to directory $HOME/dotfiles.old/"
    fi

    if [ ! -e $2 ]; then
        mkdir -p "$(dirname $2)"
        if [ "$3" = "CP" ]; then
            cp -r $DIR/$1 $2
            mod="$4"
        else
            ln -sf $DIR/$1 $2
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
    bashrc              @  bash/bashrc
    ccache.config       @  ccache/config
    chktexrc            @  .chktexrc
    cshrc               @  csh/.cshrc
    dosbox.conf         @  dosbox/dosbox.conf
    env                 @  env
    env/mimeapps.list   @  mimeapps.list
    env/user-dirs.dirs  @  user-dirs.dirs
    feh/                @  feh
    fish/               @  fish
    gdbinit             @  gdb/init
    git/                @  git
    grip.py             @  grip/grip.py
    gtkrc-2.0           @  gtk-2.0/gtkrc
    htoprc              @  htop/htoprc                          -w
    i3/                 @  i3
    inputrc             @  readline/inputrc
    mailcap             @  mailcap
    mpv/                @  mpv
    muttrc              @  mutt/muttrc
    myclirc             @  mycli/myclirc
    newsboat            @  newsboat/config
    npmrc               @  npm/npmrc
    python_config.py    @  python/config.py
    QuiteRss.ini        @  QuiteRss/QuiteRss.ini                CP
    ranger.conf         @  ranger/rc.conf
    Renviron            @  R/Renviron
    shell/              @  shell
    spicy_settings      @  spicy/settings
    ssh_config          @  ssh/config
    ssr.conf            @  simplescreenrecorder/settings.conf   CP
    tmux.conf           @  tmux/tmux.conf
    transmission.json   @  transmission/settings.json           CP
    uncrustify/         @  uncrustify
    vim/                @  vim
    weechat/            @  weechat
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

linking  bin/         $XDG_LOCAL_HOME/bin/scripts
linking  templates/   $XDG_TEMPLATES_DIR

# "PATCHING" {{{1

patch_dir="$XDG_LOCAL_HOME/bin/_patch"
find "$patch_dir" -type l -delete # clean old symlinks to wrappers

prompt_sudo="$(sudo -nv 2>&1)"
if [ $? -eq 0 ] || echo "$prompt_sudo" | grep -q '^sudo: a password'; then
    hasSudo=1
fi

# xdg_wrapper.sh {{{2
for exe in $(sed -n -e 's/^#~ //p' "$DIR/_patch/xdg_wrapper.sh"); do
    exe="$(echo $exe | cut -f1 -d'#')"
    [ -x "$(command -v $exe)" ] && linking  _patch/xdg_wrapper.sh  $patch_dir/$exe
done
chmod u+x $DIR/_patch/xdg_wrapper.sh

# /etc/profile.d/xdg_profile.sh {{{2
if [ $hasSudo ] && [ ! -f /etc/profile.d/xdg_profile.sh ]; then
    printf 'Install root patches for XDG support for 'profile' file? [y/N] '
    read -r REPLY
    if [ "$REPLY" = "y" -o "$REPLY" = "Y" ]; then
        sudo install -Dm644 $DIR/_patch/xdg_profile.sh /etc/profile.d/xdg_profile.sh
    fi
fi
[ ! -f /etc/profile.d/xdg_profile.sh ] && linking  env/profile  $HOME/.profile

# pam_environment {{{2
if [ $hasSudo ] && ! grep -q "XDG_CONFIG_HOME" /etc/security/pam_env.conf; then
    printf 'Append XDG variables to /etc/security/pam_env.conf? [y/N] '
    read -r REPLY
    if [ "$REPLY" = "y" -o "$REPLY" = "Y" ]; then
        sudo tee -a /etc/security/pam_env.conf < $DIR/env/pam > /dev/null
    fi
fi
grep -q "XDG_CONFIG_HOME" /etc/security/pam_env.conf || linking  env/pam  $HOME/.pam_environment

# ~ {{{2

mkdir -p "$(dirname $DCONF_PROFILE)" && touch "$DCONF_PROFILE" # prevents creating ~/.dconf
mkdir -p $XDG_DATA_HOME/alsa
