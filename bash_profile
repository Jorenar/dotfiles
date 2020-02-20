# BASH_PROFILE #

source $HOME/.bashrc

# If there is display and variable AUTO_STARTX is set then on tty1 `startx`
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && [[ "$(export -p | grep AUTO_STARTX)" ]] && [[ ! -f /tmp/disable_auto_startx ]]; then

    # This is for optimus-manager
    sudo /usr/bin/prime-switch

    if [[ -z $XINITRC ]]; then
        exec startx
    else
        exec startx $XINITRC
    fi
elif [[ -f /tmp/disable_auto_startx ]]; then
    rm /tmp/disable_auto_startx
fi
