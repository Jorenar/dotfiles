
# BASH_PROFILE #

source $HOME/.bashrc

# If there is display then on tty1 then `startx`
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    sudo /usr/bin/prime-switch
    exec startx
fi
