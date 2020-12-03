#!/usr/bin/env sh
# vim: fdm=marker fen

# Init {{{1

force_flag=$1
DIR="$(dirname $(realpath $0))"

sh -c "cd $DIR/_deps/ && sh download.sh"

. $DIR/env/variables

chmod -R +x bin/

# linking FUNCTION {{{

# 1st argument - file in dotfiles dir
# 2nd argument - location of link
# 3rd argument - permissions

linking() {
    if [ "$force_flag" = "-f" ] && [ -e "$2" ]; then
        mkdir -p $HOME/dotfiles.old/
        mv "$2" "$HOME/dotfiles.old/"
        echo "Moved file $2 to directory $HOME/dotfiles.old/"
    fi

    if [ ! -e $2 ]; then
        mkdir -p "$(dirname $2)"
        ln -sf $DIR/$1 $2
    fi

    if [ -n "$3" ]; then
        chmod "$3" "$2"
    fi
} # }}}

# LITE {{{1
if [ "$1" = "--lite" -o "$2" = "--lite" ]; then
    linking  bin/scripts/      $XDG_LOCAL_HOME/scripts
    linking  bin/wrappers/     $XDG_LOCAL_HOME/wrappers
    linking  git/              $XDG_CONFIG_HOME/git
    linking  mpv/              $XDG_CONFIG_HOME/mpv
    linking  vim/              $HOME/.vim

    exit
fi
# FULL {{{1
# MAIN LINKING {{{2

linking  aerc/             $XDG_CONFIG_HOME/aerc
linking  asoundrc          $XDG_CONFIG_HOME/alsa/asoundrc
linking  bashrc            $XDG_CONFIG_HOME/bash/bashrc
linking  cshrc             $XDG_CONFIG_HOME/csh/.cshrc  # thanks to wrapper
linking  dosbox.conf       $XDG_CONFIG_HOME/dosbox/dosbox.conf
linking  env               $XDG_CONFIG_HOME/env
linking  feh/              $XDG_CONFIG_HOME/feh
linking  fish/             $XDG_CONFIG_HOME/fish
linking  gdbinit           $XDG_CONFIG_HOME/gdb/init
linking  git/              $XDG_CONFIG_HOME/git
linking  htoprc            $XDG_CONFIG_HOME/htop/htoprc        -w
linking  i3/               $XDG_CONFIG_HOME/i3
linking  mimeapps.list     $XDG_CONFIG_HOME/mimeapps.list
linking  mpv/              $XDG_CONFIG_HOME/mpv
linking  muttrc            $XDG_CONFIG_HOME/mutt/muttrc
linking  myclirc           $XDG_CONFIG_HOME/mycli/myclirc
linking  newsboat/config   $XDG_CONFIG_HOME/newsboat/config
linking  ranger            $XDG_CONFIG_HOME/ranger/rc.conf
linking  shell/            $XDG_CONFIG_HOME/shell
linking  spicy_settings    $XDG_CONFIG_HOME/spicy/settings # linking is nulled after each run and replcaced with copy
linking  ssh_config        $XDG_CONFIG_HOME/ssh/config
linking  tmux.conf         $XDG_CONFIG_HOME/tmux/tmux.conf
linking  user-dirs.dirs    $XDG_CONFIG_HOME/user-dirs.dirs
linking  X11/              $XDG_CONFIG_HOME/X11
linking  zathurarc         $XDG_CONFIG_HOME/zathura/zathurarc

linking  ccache.config     $CCACHE_CONFIGPATH
linking  gpg-agent.conf    $GNUPGHOME/gpg-agent.conf
linking  gtkrc-2.0         ${GTK2_RC_FILES%:*} # link only real gtkrc, omit the one from GTK_THEME
linking  inputrc           $INPUTRC
linking  mailcap           $MAILCAP
linking  npmrc             $NPM_CONFIG_USERCONFIG
linking  python_config.py  $PYTHONSTARTUP
linking  uncrustify/       $(dirname $UNCRUSTIFY_CONFIG)
linking  vim/              $VIMDOTDIR
linking  zshrc             $ZDOTDIR/.zshrc

linking  app.desktop.d/    $XDG_DATA_HOME/applications/custom
linking  fonts/            $XDG_DATA_HOME/fonts
linking  themes/           $XDG_DATA_HOME/themes

linking  bin/scripts/      $XDG_LOCAL_HOME/bin/scripts
linking  bin/wrappers/     $XDG_LOCAL_HOME/bin/wrappers

linking firefox/user.js         $XDG_DATA_HOME/firefox/user.js
linking firefox/userContent.css $XDG_DATA_HOME/firefox/chrome/userContent.css

# INSTALL LIBS {{{2

# libJOREN
if [ -z "$(ldconfig -p | grep 'joren')" ]; then
    if [ ! -e "$XDG_LIB_DIR/c/libjoren.so" ]; then
        sh -c 'cd _deps/libJOREN && ./autogen.sh --XDG && make install'
    fi
fi

# joren.sh.d
linking  _deps/joren.sh.d  $XDG_LIB_DIR/shell/joren.sh.d

# libProgWrap
sh -c 'cd _deps/libProgWrap && make install'

# "PATCHING" {{{2
# ~misc {{{3
chmod +x $DIR/_patch/misc/*
for exe in $DIR/_patch/misc/*; do
    [ -x "$(command -v $(basename $exe))" ] && linking  "_patch/misc/$(basename $exe)"  "$_PATCH_WRAPPERS/misc/$(basename $exe)"
done

# XDG Base Dir {{{3
# WRAPPERS {{{4
chmod +x $DIR/_patch/xdg_base_dir/wrappers/*

export _XDG_WRAPPERS="$_PATCH_WRAPPERS/xdg_wrappers"
# clean old symlinks to wrappers
if [ -d "$_XDG_WRAPPERS" ] && [ "$(find $_XDG_WRAPPERS -type l | wc -l)" -eq "$(ls -1 $_XDG_WRAPPERS | wc -l)" ]; then
    rm -r "$_XDG_WRAPPERS"
fi

# Link wrappers
for exe in $DIR/_patch/xdg_base_dir/wrappers/*; do
    [ -x "$(command -v $(basename $exe))" ] && linking  "_patch/xdg_base_dir/wrappers/$(basename $exe)"  "$_XDG_WRAPPERS/$(basename $exe)"
done

[ -x "$(command -v scp)"  ] && linking  _patch/xdg_base_dir/wrappers/ssh  $_XDG_WRAPPERS/scp
[ -x "$(command -v tcsh)" ] && linking  _patch/xdg_base_dir/wrappers/csh  $_XDG_WRAPPERS/tcsh

# Generate FAKEHOME wrappers
while IFS= read -r exe; do
    exe="$(echo $exe | cut -f1 -d'#')"
    [ -n "$exe" ] && [ -x "$(command -v $exe)" ] && linking  _patch/xdg_base_dir/wrappers/_xdg_fakehome.sh  $_XDG_WRAPPERS/$exe
done < "$DIR/_patch/xdg_base_dir/fakehome.list"

# Compile wrappers
make -C $DIR/_patch/xdg_base_dir/wrappers/src > /dev/null

# Install /etc/profile.d/profile_xdg.sh ? {{{4

# Check if user has sudo privileges
prompt_sudo=$(sudo -nv 2>&1)
if [ $? -eq 0 ] || echo "$prompt_sudo" | grep -q '^sudo:'; then
    is_sudo=true
else
    is_sudo=false
fi

status=no
if [ ! -f /etc/profile.d/profile_xdg.sh ]; then
    if [ $is_sudo = true ]; then
        printf 'Do you wish to install root patches for XDG support for 'profile' file? [y/N] '
        read -r REPLY
        if [ "$REPLY" = "y" -o "$REPLY" = "Y" ]; then
            status=installing
        fi
    fi
else
    status=installed
fi

if [ "$status" = "installing" ]; then
    sudo ln -sf $DIR/_patch/xdg_base_dir/profile_xdg.sh /etc/profile.d/profile_xdg.sh
    sudo chmod 644 /etc/profile.d/profile_xdg.sh  # just in case
elif [ $status != installed ]; then
    linking  env/profile  $HOME/.profile
fi

# OTHER {{{2
mkdir -p "$(dirname $DCONF_PROFILE)" && touch "$DCONF_PROFILE" # prevents creating ~/.dconf
mkdir -p $XDG_DATA_HOME/alsa
