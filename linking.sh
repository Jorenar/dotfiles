linking() {
    if [[ $1 == "-f" ]]; then
        rm -rf $3
    fi

    if [ ! -e $3 ]; then
        mkdir -p "$(dirname $3)"
        ln -sf $(pwd)/$2 $3
    fi
}


if [[ $1 == "-f" ]]; then
    x="-f"
else
    x="n"
fi

cd $(dirname $0)

linking  $x  gtk/gtk3_settings.ini  $HOME/.config/gtk-3.0/settings.ini
linking  $x  gtk/gtkrc-2.0          $HOME/.gtkrc-2.0
linking  $x  i3/                    $HOME/.i3
linking  $x  mpv/                   $HOME/.config/mpv
linking  $x  mutt/muttrc            $HOME/.muttrc
linking  $x  other/bashrc           $HOME/.bash_profile
linking  $x  other/bashrc           $HOME/.bashrc
linking  $x  other/feh_keys         $HOME/.config/feh/keys
linking  $x  other/gpg-agent.conf   $HOME/.gnupg/gpg-agent.conf
linking  $x  other/inputrc          $HOME/.inputrc
linking  $x  other/profile          $HOME/.profile
linking  $x  other/tmux.conf        $HOME/.tmux.conf
linking  $x  other/Xresources       $HOME/.Xresources
linking  $x  other/zathurarc        $HOME/.config/zathura/zathurarc
linking  $x  vim/colors             $HOME/.vim/colors
linking  $x  vim/indent             $HOME/.vim/indent
linking  $x  vim/UltiSnips          $HOME/.vim/UltiSnips
linking  $x  vim/vimrc              $HOME/.vimrc

# linking  $x  other/myclirc          $HOME/.myclirc

cd - > /dev/null

mkdir -p $HOME/.vim/cache/backup
mkdir -p $HOME/.vim/cache/undo
