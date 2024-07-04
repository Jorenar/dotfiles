" VisInsert
" Author:  Jorengarenar
" License: MIT

if exists('g:loaded_VisInsert') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

xnoremap I <Cmd>call VisInsert#start(v:count1.'i')<CR>

xnoremap <expr> A mode() == "\<C-v>"
      \ ? "<Cmd>call VisInsert#start(v:count1.'a')<CR>"
      \ : "<Cmd>call VisInsert#start(v:count1.'A')<CR>"

xnoremap <expr> c mode() == "\<C-v>"
      \ ? "x<Cmd>call VisInsert#start('i')<CR>"
      \ : 'c'

let g:loaded_VisInsert = 1
let &cpo = s:cpo_save | unlet s:cpo_save
