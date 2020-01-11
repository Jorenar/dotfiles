wincmd J " QuickFix window below other windows
set nocursorline nocursorcolumn
set nonumber

noremap <buffer> g- :colder<CR>
noremap <buffer> g+ :cnewer<CR>

" Quit QuickFix window along with source file window
autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix" | q | endif
