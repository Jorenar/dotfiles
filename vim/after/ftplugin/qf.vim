setlocal nocursorline nocursorcolumn
setlocal colorcolumn=
setlocal nonumber
setlocal nowrap

if !w:QfQoL_isLocList
  wincmd J
endif

autocmd WinEnter *
      \  if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"
      \|   quit
      \| endif

let qf_disable_statusline = 1
let &l:stl = ' '
      \ . (w:QfQoL_isLocList ? '[loclist]' : '[globlist]')
      \ . '  %l/%L%='
      \ . (w:QfQoL_isLocList ? '' : w:quickfix_title)
      \ . ' '

call matchadd("Error",      '^\s*\zs\[E]\ze ')
call matchadd("WarningMsg", '\c^\s*\zs\[W]\ze ')
