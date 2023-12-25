#!/usr/bin/env -S vim -u

" Author:  Jorengarenar
" License: MIT

" BASICS {{{1

set nocompatible
filetype plugin indent on
syntax enable
colorscheme slate

silent! autocmd! SLIDES

" FUNCTIONS {{{1

function! FoldText() abort
  return "+-" . v:folddashes . " " . printf("%3d", v:foldend - v:foldstart + 1) . " lines: "
        \ . trim(substitute(getline(v:foldstart), split(&l:fmr, ',')[0].'\d\?', '', '')) . " "
endfunction

function! TabLine() abort
  let TabLabel = {n -> bufname(tabpagebuflist(n)[tabpagewinnr(n) - 1])}
  let l:labels = map(range(tabpagenr("$")), 'TabLabel(v:val+1)')
  let l:labelsLenghts = map(deepcopy(l:labels), 'len(v:val)+2')
  let ReduceLen = {st,ed -> reduce(l:labelsLenghts[st:ed], {a,b -> a+b})}

  let l:last = tabpagenr('$')
  let l:cur = tabpagenr()-1

  let l:st = 0
  while ReduceLen(l:st, l:cur) > &columns
    let l:st += 1
  endwhile

  let l:ed = l:cur+1 < l:last ? l:cur+1 : l:cur
  while l:ed < l:last-1 && ReduceLen(l:st, l:ed+1) < &columns
    let l:ed += 1
  endwhile

  let l:tabline = ''
  for i in range(l:st+1, l:ed+1)
    let l:tabline .= i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
    let l:tabline .= '%' . i . 'T'   " set the tab page number (for mouse clicks)
    let l:tabline .= ' ' . l:labels[i-1] . ' '
  endfor

  let l:tabline .= '%#TabLineFill#%T'
  let l:tabline .= '%=%'

  return l:tabline
endfunction

" OPTIONS {{{1

set nobackup
set noswapfile
set noundofile
set viminfofile=NONE

set hlsearch
set laststatus=0
set mouse=a
set showtabline=2
set splitbelow splitright
set statusline=\ %f
set tabpagemax=999

set expandtab
set shiftwidth=0
set softtabstop=-1
set tabstop=4

set foldmethod=marker
set foldtext=FoldText()

set showtabline=2
set tabline=%!TabLine()

augroup SLIDES
  autocmd FileType * setlocal number
augroup END

augroup FORMATOPTIONS
  autocmd!
  autocmd BufWinEnter * set fo-=c fo-=r fo-=o " Disable continuation of comments to the next line
  autocmd BufWinEnter * set formatoptions+=j  " Remove a comment leader when joining lines
  autocmd BufWinEnter * set formatoptions+=l  " Don't break a line after a one-letter word
  autocmd BufWinEnter * set formatoptions+=n  " Recognize numbered lists
  autocmd BufWinEnter * set formatoptions-=q  " Don't format comments
  autocmd BufWinEnter * set formatoptions-=t  " Don't autowrap text using 'textwidth'
augroup END

" MAPPINGS {{{1

nnoremap <silent> <F9> :w <bar> silent! make %:t:r <bar> redraw! <bar> term %:p:r<CR>
nnoremap <silent> <C-l> :nohlsearch<C-r>=has('diff')?'<bar>diffupdate':''<CR><CR><C-l>
noremap <RightMouse> gt

" MISC. {{{1

augroup SLIDES
  autocmd WinEnter * redraw!
augroup END

let g:netrw_dirhistmax = 0

hi! Folded  cterm=italic ctermfg=245 ctermbg=NONE
hi! EndOfBuffer ctermfg=bg ctermbg=bg guifg=bg guibg=bg

" SOURCE LOCAL {{{1

if filereadable(".slides_local.vim")
  set secure
  source .slides_local.vim
endif

" ARGS {{{1

silent! args *
silent! argdelete <sfile>:.
silent! tab all
