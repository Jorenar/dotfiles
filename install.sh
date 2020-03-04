#!/usr/bin/env sh
# vim: fen

# ------------------------------------------------

force_flag=$1
DIR="$(dirname $(realpath $0))"

. $DIR/_XDG/env_variables

# ------------------------------------------------

# 1st argument - file in dotfiles dir
# 2nd argument - location of link
# 3rd argument - permissions

linking() {
    if [ "$force_flag" = "-f" ]; then
        mkdir -p $HOME/dotfiles.old/
        mv "$2" "$HOME/dotfiles.old/"
        echo "Moved file $2 to directory $HOME/dotfiles.old/"
    fi

    if [ ! -e $2 ]; then
        mkdir -p "$(dirname $2)"
        ln -sf $DIR/$1 $2
    fi

    if [ ! -z "$3" ]; then
        chmod "$3" "$2"
    fi
}

# ------------------------------------------------

linking  bashrc            $XDG_CONFIG_HOME/bash/bashrc
linking  feh/              $XDG_CONFIG_HOME/feh
linking  git/              $XDG_CONFIG_HOME/git
linking  htoprc            $XDG_CONFIG_HOME/htop/htoprc        -w
linking  i3/               $XDG_CONFIG_HOME/i3
linking  mailcap           $XDG_CONFIG_HOME/mailcap
linking  mimeapps.list     $XDG_CONFIG_HOME/mimeapps.list
linking  mpv/              $XDG_CONFIG_HOME/mpv
linking  muttrc            $XDG_CONFIG_HOME/mutt/muttrc
linking  myclirc           $XDG_CONFIG_HOME/mycli/myclirc
linking  newsboat/config   $XDG_CONFIG_HOME/newsboat/config
linking  ssh_config        $XDG_CONFIG_HOME/ssh/config
linking  tmux.conf         $XDG_CONFIG_HOME/tmux/tmux.conf
linking  user-dirs.dirs    $XDG_CONFIG_HOME/user-dirs.dirs
linking  zathurarc         $XDG_CONFIG_HOME/zathura/zathurarc

linking  gpg-agent.conf    $GNUPGHOME/gpg-agent.conf
linking  gtkrc-2.0         $GTK2_RC_FILES  # works properly, because _XDG is sourced
linking  inputrc           $INPUTRC
linking  npmrc             $NPM_CONFIG_USERCONFIG
linking  python_config.py  $PYTHONSTARTUP
linking  themes/           $XDG_FAKEHOME_DIR/.themes # for compatibility with _XDG/wrappers
linking  vim/              $VIMDOTDIR
linking  xinitrc           $XINITRC
linking  zshrc             $ZDOTDIR/.zshrc

linking  fonts/            $XDG_DATA_HOME/fonts
linking  themes/           $XDG_DATA_HOME/themes

for cfg in aerc/*; do
    linking "$cfg" $XDG_CONFIG_HOME/aerc/"$(basename $cfg)"
done

for firefox_profile in $XDG_FAKEHOME_DIR/.mozilla/firefox/*.default-release; do
    linking userContent.css "$firefox_profile/chrome/userContent.css"
done

touch $DCONF_PROFILE

# ------------------------------------------------

. $DIR/_XDG/install.sh
