setlocal colorcolumn=
setlocal nonumber
setlocal noswapfile

if !empty($MAN_PN)
  silent! file $MAN_PN
endif
