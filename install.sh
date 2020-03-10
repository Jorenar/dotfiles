#!/usr/bin/env sh
# vim: fdm=marker fen

# ------------------------------------------------

force_flag=$1
DIR="$(dirname $(realpath $0))"

. $DIR/env_variables

# ------------------------------------------------

# 1st argument - file in dotfiles dir
# 2nd argument - location of link
# 3rd argument - permissions

linking() { # {{{
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

# ------------------------------------------------

linking  aerc/               $XDG_CONFIG_HOME/aerc
linking  autostart/          $XDG_CONFIG_HOME/autostart
linking  bashrc              $XDG_CONFIG_HOME/bash/bashrc
linking  env_variables       $XDG_CONFIG_HOME/env_variables
linking  feh/                $XDG_CONFIG_HOME/feh
linking  git/                $XDG_CONFIG_HOME/git
linking  htoprc              $XDG_CONFIG_HOME/htop/htoprc        -w
linking  i3/                 $XDG_CONFIG_HOME/i3
linking  mimeapps.list       $XDG_CONFIG_HOME/mimeapps.list
linking  mpv/                $XDG_CONFIG_HOME/mpv
linking  muttrc              $XDG_CONFIG_HOME/mutt/muttrc
linking  myclirc             $XDG_CONFIG_HOME/mycli/myclirc
linking  newsboat/config     $XDG_CONFIG_HOME/newsboat/config
linking  profile             $XDG_CONFIG_HOME/profile
linking  shell/              $XDG_CONFIG_HOME/shell
linking  ssh_config          $XDG_CONFIG_HOME/ssh/config
linking  tmux.conf           $XDG_CONFIG_HOME/tmux/tmux.conf
linking  user-dirs.dirs      $XDG_CONFIG_HOME/user-dirs.dirs
linking  X11/                $XDG_CONFIG_HOME/X11
linking  zathurarc           $XDG_CONFIG_HOME/zathura/zathurarc

linking  gpg-agent.conf      $GNUPGHOME/gpg-agent.conf
linking  gtkrc-2.0           ${GTK2_RC_FILES%:*}  #
linking  inputrc             $INPUTRC
linking  mailcap             $MAILCAP
linking  npmrc               $NPM_CONFIG_USERCONFIG
linking  python_config.py    $PYTHONSTARTUP
linking  themes/             $XDG_FAKEHOME_DIR/.themes # for compatibility with _XDG_wrappers
linking  vim/                $VIMDOTDIR
linking  zshrc               $ZDOTDIR/.zshrc

linking  desktop_entries     $XDG_DATA_HOME/applications/custom
linking  fonts/              $XDG_DATA_HOME/fonts
linking  themes/             $XDG_DATA_HOME/themes

for firefox_profile in $XDG_FAKEHOME_DIR/.mozilla/firefox/*.default-release; do
    linking userContent.css "$firefox_profile/chrome/userContent.css"
done

touch $DCONF_PROFILE

# WRAPPERS {{{1

chmod +x $DIR/_patch/xdg_base_dir/wrappers/*

[ -z "(ls -A $_XDG_WRAPPERS)" ] && rm $_XDG_WRAPPERS/* # clean directory (from old links to wrappers)

# Link wrappers
for exe in $DIR/_patch/xdg_base_dir/wrappers/*; do
    [ -e "$exe" ] && [ -x "$(command -v $(basename $exe))" ] && linking  "_patch/xdg_base_dir/wrappers/$(basename $exe)"  "$_XDG_WRAPPERS/$(basename $exe)"
done

linking  _patch/xdg_base_dir/wrappers/ssh  $_XDG_WRAPPERS/scp

# Generate FAKEHOME wrappers
while IFS= read -r exe; do
    exe="$(echo $exe | cut -f1 -d'#')"
    [ -n "$exe" ] && [ -x "$(command -v $exe)" ] && linking  _patch/xdg_base_dir/wrappers/_xdg_fakehome.sh  $_XDG_WRAPPERS/$exe
done < "$DIR/_patch/xdg_base_dir/fakehome.list"


# Sudo patches {{{1
# Check if user has sudo privileges {{{2
prompt_sudo=$(sudo -nv 2>&1)
if [ $? -eq 0 ] || echo "$prompt_sudo" | grep -q '^sudo:'; then
    is_sudo=true
else
    is_sudo=false
fi

# 'profile' file {{{2
status=no
if [ ! -f /etc/profile.d/profile_xdg.sh ]; then
    if [ $is_sudo = true ]; then
        printf 'Do you wish to install root patches for XDG support for 'profile' file? [y/N] '
        read -r REPLY
        if [ -n "$REPLY" ] && [ $REPLY = "y" -o $REPLY = "Y" ]; then
            status=installing
        fi
    fi
else
    status=installed
fi

if [ "$status" = "installing" ]; then
    sudo ln -sf $DIR/_patch/xdg_base_dir/profile_xdg.sh /etc/profile.d/profile_xdg.sh
    sudo chmod r-w /etc/profile.d/profile_xdg.sh  # just in case
elif [ $status != installed ]; then
    linking  profile  $HOME/.profile
fi
