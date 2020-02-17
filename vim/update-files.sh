#!/usr/bin/env sh

dl() {
    mkdir -p "$1"
    (cd "$1" && curl -O "$2")
}

dl $VIMDOTDIR/syntax https://raw.githubusercontent.com/leafgarland/typescript-vim/master/syntax/typescript.vim
dl $VIMDOTDIR/plugin http://cscope.sourceforge.net/cscope_maps.vim
