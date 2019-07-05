#!/bin/bash

# ------------------------------------------------

# 1st argument - file in dotfiles dir
# 2nd argument - location of link
# 3rd argument - deactivation flag

# ------------------------------------------------

declare dotfiles_dir="$(dirname $(realpath $0))"
declare force_flag=$1

# ------------------------------------------------

linking() {
    if [[ $3 == "D" || $4 == "D" ]]; then
        dotfiles_dir_temp=""
    else
        dotfiles_dir_temp=$dotfiles_dir
    fi
    if [[ $3 == "X" ]]; then
        if [[ -L $2 && "$(readlink -f $2)" == "$dotfiles_dir_temp/$1" ]]; then
            rm $2
        fi
    else
        if [[ $force_flag == "-f" ]]; then
            mkdir -p $HOME/dotfiles.old/
            mv "$2" "$HOME/dotfiles.old/"
            echo "Moved file $2 to directory $HOME/dotfiles.old/"
        fi

        if [ ! -e $2 ]; then
            mkdir -p "$(dirname $2)"
            ln -sf $dotfiles_dir_temp/$1 $2
        fi
    fi
}

# ------------------------------------------------

linking  git/gitconfig          $HOME/.gitconfig
linking  gtk/gtk3_settings.ini  $HOME/.config/gtk-3.0/settings.ini
linking  gtk/gtkrc-2.0          $HOME/.gtkrc-2.0
linking  i3/                    $HOME/.i3
linking  mpv/                   $HOME/.config/mpv
linking  mutt/muttrc            $HOME/.muttrc
linking  other/bashrc           $HOME/.bash_profile
linking  other/bashrc           $HOME/.bashrc
linking  other/feh_keys         $HOME/.config/feh/keys
linking  other/gpg-agent.conf   $HOME/.gnupg/gpg-agent.conf
linking  other/inputrc          $HOME/.inputrc
linking  other/myclirc          $HOME/.myclirc                      "X"
linking  other/profile          $HOME/.profile
linking  other/tmux.conf        $HOME/.tmux.conf
linking  other/Xresources       $HOME/.Xresources
linking  other/zathurarc        $HOME/.config/zathura/zathurarc
linking  tig/tigrc              $HOME/.tigrc
linking  vim/init.vim           $HOME/.config/nvim/init.vim
linking  vim/init.vim           $HOME/.vimrc
linking  vim/UltiSnips          $HOME/.config/nvim/UltiSnips

linking  $HOME/.config/nvim     $HOME/.vim                          "D"
