" lcscope
" Author:  Jorengarenar <https://joren.ga>
" License: MIT

if exists('g:loaded_lcscope') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

function! s:lcscope() abort
  copen
  let [ s:ch_old, &ch ] = [ &cmdheight, 2 ]
  let s:list = getqflist()
  call setloclist(s:winid, s:list)
  call setloclist(s:winid, [], 'a', { "title": w:quickfix_title })
  if s:ccl | cclose | endif
  if len(s:list) == 1 | lclose | else | lopen | endif

  autocmd CursorMoved * ++once
        \   call setqflist([], 'r', {"title": ""})
        \ | silent! colder
        \ | let &ch = s:ch_old
        \ | echo

endfunction

augroup LCSCOPE
  autocmd!

  autocmd QuickFixCmdPre cscope
        \   let s:winid = win_getid()
        \ | let s:ccl = empty(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist'))

  autocmd QuickFixCmdPost cscope call s:lcscope()

augroup END

let g:loaded_lcscope = 1
let &cpo = s:cpo_save | unlet s:cpo_save
