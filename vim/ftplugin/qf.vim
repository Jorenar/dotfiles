setlocal nocursorline nocursorcolumn
setlocal colorcolumn=
setlocal nonumber
setlocal nowrap

let w:is_loclist = getwininfo(win_getid())[0]['loclist']

if !w:is_loclist
  wincmd J
endif

if w:is_loclist
  noremap <buffer> g- :lolder<CR>
  noremap <buffer> g+ :lnewer<CR>
else
  noremap <buffer> g- :colder<CR>
  noremap <buffer> g+ :cnewer<CR>
endif

" Quit QuickFix window along with source file window
autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix" | q | endif

let qf_disable_statusline = 1
setlocal stl=\ %t\ \ %l/%L%=
if !w:is_loclist
  setlocal stl+=%{w:quickfix_title}
endif
setlocal stl+=\  " comm to prevent trimming space

call matchadd("Error",      '^\s*\zs\[E]\ze ')
call matchadd("WarningMsg", '\c^\s*\zs\[W]\ze ')
call matchadd("Error",      '\cerror')
call matchadd("WarningMsg", '\cwarning')
