#!/usr/bin/env sh

# ------------------------------------------------

# 1st argument - file in dotfiles dir
# 2nd argument - location of link

# ------------------------------------------------

declare DIR="$(dirname $(realpath $0))"

source $DIR/_XDG/env_variables

declare force_flag=$1

# ------------------------------------------------

linking() {
    if [[ $force_flag = "-f" ]]; then
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

source $DIR/_XDG/patch/install.sh
sh $DIR/_XDG/chmod_wrappers.sh

# ------------------------------------------------


linking  htoprc            $XDG_CONFIG_HOME/htop/htoprc        -w
linking  mimeapps.list     $XDG_CONFIG_HOME/mimeapps.list
linking  ssh_config        $XDG_CONFIG_HOME/ssh/config
linking  user-dirs.dirs    $XDG_CONFIG_HOME/user-dirs.dirs
linking  zathurarc         $XDG_CONFIG_HOME/zathura/zathurarc

linking  feh/              $XDG_CONFIG_HOME/feh
linking  git/              $XDG_CONFIG_HOME/git
linking  i3/               $XDG_CONFIG_HOME/i3
linking  mpv/              $XDG_CONFIG_HOME/mpv

linking  bashrc            $BASH_HOME/bashrc
linking  gpg-agent.conf    $GNUPGHOME/gpg-agent.conf
linking  gtkrc-2.0         $GTK2_RC_FILES  # works properly, because _XDG is sourced
linking  inputrc           $INPUTRC
linking  npmrc             $NPM_CONFIG_USERCONFIG
linking  python_config.py  $PYTHONSTARTUP
linking  vim/              $VIMDOTDIR
linking  xinitrc           $XINITRC
linking  zshrc             $ZDOTDIR/.zshrc

linking  fonts/            $XDG_DATA_HOME/fonts
linking  themes/           $XDG_DATA_HOME/themes
linking  themes/           $XDG_FAKE_HOME/.themes # second time for compability with _XDG/wrappers

for cfg in aerc/*; do
    linking "$cfg" $XDG_CONFIG_HOME/aerc/"$(basename $cfg)"
done

for firefox_profile in $HOME/.mozilla/firefox/*.default-release; do
    linking userContent.css "$firefox_profile/chrome/userContent.css"
done

chmod +x $DIR/autostart.sh

touch $DCONF_PROFILE

# ------------------------------------------------

# linking  mailcap           $HOME/.mailcap
# linking  muttrc            $XDG_CONFIG_HOME/mutt/muttrc
# linking  myclirc           $HOME/.myclirc
# linking  newsboat/config   $XDG_CONFIG_HOME/newsboat/config
# linking  tmux.conf         $XDG_CONFIG_HOME/tmux/tmux.conf

# ------------------------------------------------
# vim: fen
