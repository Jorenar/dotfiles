linking() {
    if [[ $1 == "-f" ]]; then
        rm -rf $3
    fi

    if [ ! -e $3 ]; then
        mkdir -p "$(dirname $3)"
        ln -sf $(pwd)/$2 $3
    fi
}

cd $(dirname $0)

linking  $1  gtk/gtk3_settings.ini  $HOME/.config/gtk-3.0/settings.ini
linking  $1  gtk/gtkrc-2.0          $HOME/.gtkrc-2.0
linking  $1  i3/                    $HOME/.i3
linking  $1  mpv/                   $HOME/.config/mpv
linking  $1  mutt/muttrc            $HOME/.muttrc
linking  $1  other/bashrc           $HOME/.bash_profile
linking  $1  other/bashrc           $HOME/.bashrc
linking  $1  other/feh_keys         $HOME/.config/feh/keys
linking  $1  other/gitconfig        $HOME/.gitconfig
linking  $1  other/gpg-agent.conf   $HOME/.gnupg/gpg-agent.conf
linking  $1  other/inputrc          $HOME/.inputrc
linking  $1  other/profile          $HOME/.profile
linking  $1  other/tmux.conf        $HOME/.tmux.conf
linking  $1  other/vim.tigrc        $HOME/.tigrc
linking  $1  other/Xresources       $HOME/.Xresources
linking  $1  other/zathurarc        $HOME/.config/zathura/zathurarc
linking  $1  vim/colors             $HOME/.vim/colors
linking  $1  vim/indent             $HOME/.vim/indent
linking  $1  vim/UltiSnips          $HOME/.vim/UltiSnips
linking  $1  vim/vimrc              $HOME/.vimrc

# linking  $x  other/myclirc          $HOME/.myclirc

cd - > /dev/null

mkdir -p $HOME/.vim/cache/backup
mkdir -p $HOME/.vim/cache/undo
