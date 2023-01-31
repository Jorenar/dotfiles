setlocal nocursorline nocursorcolumn
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
