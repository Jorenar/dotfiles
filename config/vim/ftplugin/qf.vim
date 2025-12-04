let w:QfQoL_isLocList = getwininfo(win_getid())[0]['loclist']

if w:QfQoL_isLocList
  noremap <buffer> g- :lolder<CR>
  noremap <buffer> g+ :lnewer<CR>
else
  noremap <buffer> g- :colder<CR>
  noremap <buffer> g+ :cnewer<CR>
endif

command! -buffer -nargs=*  Sort  call QfQoL#sort("<args>")

nnoremap <buffer> <expr> <C-v> &splitright ? "\<C-W>\<CR>\<C-W>L" : "\<C-W>\<CR>\<C-W>H"
nnoremap <buffer> <C-s> <C-w><CR>

setlocal nocursorline nocursorcolumn
setlocal colorcolumn=
setlocal signcolumn=no
setlocal foldcolumn=0
setlocal nonumber
let qf_number = 0

let qf_disable_statusline = 1
let &l:stl = ' '
      \ . (w:QfQoL_isLocList ? '[loclist]' : '[globlist]')
      \ . '  %l/%L%='
      \ . (w:QfQoL_isLocList ? '' : get(w:, 'quickfix_title', ''))
      \ . ' '

call matchadd("ErrorMsg",   '^\s*\zs\[E]\ze ')
call matchadd("WarningMsg", '\c^\s*\zs\[W]\ze ')
call matchadd("ALEInfo",    '\c^\s*\zs\[[IN]]\ze ')
