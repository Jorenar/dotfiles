let w:QfQoL_isLocList = getwininfo(win_getid())[0]['loclist']

if w:QfQoL_isLocList
  noremap <buffer> g- :lolder<CR>
  noremap <buffer> g+ :lnewer<CR>
else
  noremap <buffer> g- :colder<CR>
  noremap <buffer> g+ :cnewer<CR>
endif

command! -buffer -nargs=*  Sort
      \ call QfQoL#sort("<args>")

" ------------------------------------------------------------------------------

setlocal nocursorline nocursorcolumn
setlocal colorcolumn=
autocmd BufReadPost <buffer> ++once setlocal nonumber

let qf_disable_statusline = 1
let &l:stl = ' '
      \ . (w:QfQoL_isLocList ? '[loclist]' : '[globlist]')
      \ . '  %l/%L%='
      \ . (w:QfQoL_isLocList ? '' : get(w:, 'quickfix_title', '')
      \ . ' '

call matchadd("Error",      '^\s*\zs\[E]\ze ')
call matchadd("WarningMsg", '\c^\s*\zs\[W]\ze ')
