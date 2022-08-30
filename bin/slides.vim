#!/usr/bin/env -S vim +so

set colorcolumn=
set laststatus=0
set mouse=a
set signcolumn=no
set statusline=\ %f

ColorUp

let g:ale_enabled=0
let g:lsp_diagnostics_highlights_enabled = 0

augroup SLIDES
  autocmd TerminalOpen * call feedkeys("PS1='$ ';clear\n")
  autocmd WinEnter * redraw!
augroup END

nnoremap <silent> <F9> :w <bar> silent! make %:p <bar> redraw! <bar> term %:p:r<CR>

args * | tab all
