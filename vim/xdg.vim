if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME."/.cache"       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME."/.config"      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME."/.local/share" | endif

set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after
set runtimepath+=$XDG_DATA_HOME/vim
set packpath^=$XDG_DATA_HOME/vim

set backupdir=$XDG_CACHE_HOME/vim/backup | call mkdir(&backupdir, 'p', 0700)
set directory=$XDG_CACHE_HOME/vim/swap   | call mkdir(&directory, 'p', 0700)
set undodir=$XDG_CACHE_HOME/vim/undo     | call mkdir(&undodir,   'p', 0700)
set viewdir=$XDG_CACHE_HOME/vim/view     | call mkdir(&viewdir,   'p', 0700)

if !has('nvim') " Neovim has its own special location
  set viminfofile=$XDG_CACHE_HOME/vim/viminfo
endif

call mkdir($XDG_DATA_HOME."/vim/spell", 'p', 0700)

if empty($MYVIMRC)
  let $MYVIMRC = $XDG_CONFIG_HOME . "/vim/vimrc"
endif

source $MYVIMRC
