#!/bin/bash

# ------------------------------------------------

# 1st argument - file in dotfiles dir
# 2nd argument - location of link

# ------------------------------------------------

declare dotfiles_dir="$(dirname $(realpath $0))"

source $dotfiles_dir/xdg

declare force_flag=$1

# ------------------------------------------------

linking() {
    if [[ $force_flag == "-f" ]]; then
        mkdir -p $HOME/dotfiles.old/
        mv "$2" "$HOME/dotfiles.old/"
        echo "Moved file $2 to directory $HOME/dotfiles.old/"
    fi

    if [ ! -e $2 ]; then
        mkdir -p "$(dirname $2)"
        ln -sf $dotfiles_dir/$1 $2
    fi
}

# ------------------------------------------------

linking  bash_profile      $HOME/.bash_profile
linking  bashrc            $HOME/.bashrc
linking  profile           $HOME/.profile
linking  themes            $HOME/.themes

linking  user-dirs.dirs    $XDG_CONFIG_HOME/user-dirs.dirs
linking  zathurarc         $XDG_CONFIG_HOME/zathura/zathurarc

linking  feh               $XDG_CONFIG_HOME/feh
linking  git               $XDG_CONFIG_HOME/git
linking  i3/               $XDG_CONFIG_HOME/i3
linking  mpv/              $XDG_CONFIG_HOME/mpv

linking  gpg-agent.conf    $GNUPGHOME/gpg-agent.conf
linking  gtkrc-2.0         $GTK2_RC_FILES
linking  inputrc           $INPUTRC
linking  python_config.py  $PYTHONSTARTUP
linking  vim/              $VIMDOTDIR
linking  xinitrc           $XINITRC

linking  fonts             $XDG_DATA_HOME/fonts

for cfg in aerc/*; do
    linking "$cfg" $XDG_CONFIG_HOME/aerc/"$(basename $cfg)"
done

# ------------------------------------------------

# linking  mailcap           $HOME/.mailcap
# linking  muttrc            $XDG_CONFIG_HOME/mutt/muttrc
# linking  myclirc           $HOME/.myclirc
# linking  tig               $XDG_CONFIG_HOME/tig
# linking  tmux.conf         $HOME/.tmux.conf
