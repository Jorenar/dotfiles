
# BASH_PROFILE #

source $HOME/.bashrc

# If there is display and variable AUTO_STARTX is set then on tty1 `startx`
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && [[ ! -z ${AUTO_STARTX+x} ]]; then

    sudo /usr/bin/prime-switch

    if [[ -z $XINITRC ]]; then
        exec startx
    else
        exec startx -x $XINITRC
    fi
fi
