#!/usr/bin/env -S vim -u

set nocompatible
filetype plugin indent on
syntax enable

set colorcolumn=
set laststatus=0
set mouse=a
set showtabline=2
set signcolumn=no
set statusline=\ %f
set tabpagemax=999

set nobackup
set noswapfile
set noundofile
set viminfofile=NONE

augroup SLIDES
  autocmd TerminalOpen * call feedkeys("PS1='$ ';clear\n")
  autocmd WinEnter * redraw!
augroup END

nnoremap <silent> <F9> :w <bar> silent! make %:p <bar> redraw! <bar> term %:p:r<CR>

hi! Comment                ctermfg=240
hi! TabLine     cterm=NONE ctermfg=240 ctermbg=234
hi! TabLineFill cterm=NONE ctermfg=249 ctermbg=234
hi! TabLineSel  cterm=NONE ctermfg=249 ctermbg=233

silent! args * | silent! tab all
