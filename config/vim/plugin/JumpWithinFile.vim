" JumpWithinFile
" Source: https://stackoverflow.com/a/7075070

if exists('g:loaded_JumpWithinFile') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

function! JumpWithinFile(back, forw) abort
  let [n, i] = [bufnr('%'), 1]
  let p = [n] + getpos('.')[1:]
  sil! exe 'norm! 1' . a:forw
  while 1
    let p1 = [bufnr('%')] + getpos('.')[1:]
    if n == p1[0] | break | endif
    if p == p1
      sil! exe 'norm!' (i-1) . a:back
      break
    endif
    let [p, i] = [p1, i+1]
    sil! exe 'norm! 1' . a:forw
  endwhile
endfunction

let g:JumpWithinFile = get(g:, "JumpWithinFile", 0)

nnoremap <expr> <C-o>
      \   g:JumpWithinFile
      \ ? '<Cmd>call JumpWithinFile("\<C-i>", "\<C-o>")<CR>'
      \ : "\<C-o>"

nnoremap <expr> <C-i>
      \   g:JumpWithinFile
      \ ? '<Cmd>call JumpWithinFile("\<C-o>", "\<C-i>")<CR>'
      \ : "\<C-i>"

exec 'nnoremap <C-'.get(g:, "mapleader", '\').'><C-o>'
      \ '<Cmd>let g:JumpWithinFile = !JumpWithinFile<CR>'

let g:loaded_JumpWithinFile = 1
let &cpo = s:cpo_save | unlet s:cpo_save
