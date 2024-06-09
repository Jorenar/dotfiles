setlocal colorcolumn=
setlocal nonumber
setlocal noswapfile
setlocal signcolumn=no

if !empty($MAN_PN)
  silent! file $MAN_PN
endif

setlocal laststatus=1
setlocal stl=\ %f
setlocal ruler
