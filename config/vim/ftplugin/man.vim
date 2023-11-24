setlocal colorcolumn=
setlocal nonumber
setlocal noswapfile

if !empty($MAN_PN)
  silent! file $MAN_PN
endif

setlocal laststatus=1
setlocal stl=\ %f
setlocal ruler
