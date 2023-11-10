" blockdiff
" Author:  Jorengarenar
" License: MIT

if exists('g:loaded_blockdiff') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

let s:blocks = []

function! BlockDiff() abort
  tabnew
  for block in s:blocks
    vnew
    call setline(1, block)
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    diffthis
  endfor

  " wrap to first (empty) buffer and wipe it
  wincmd w | bwipeout
endfunction

command! BlockDiffShow     call BlockDiff()
command! BlockDiffClean    let s:blocks = []
command! -range BlockDiff  let s:blocks += [ getline(<line1>, <line2>) ]

let g:loaded_blockdiff = 1
let &cpo = s:cpo_save | unlet s:cpo_save
