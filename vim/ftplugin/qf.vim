wincmd J " QuickFix window below other windows
setlocal nocursorline nocursorcolumn
setlocal nonumber
setlocal wrap

if getwininfo(win_getid())[0]['quickfix']
  noremap <buffer> g- :colder<CR>
  noremap <buffer> g+ :cnewer<CR>
else
  noremap <buffer> g- :lolder<CR>
  noremap <buffer> g+ :lnewer<CR>
endif

" Quit QuickFix window along with source file window
autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix" | q | endif
