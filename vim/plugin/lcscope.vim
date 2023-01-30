" lcscope
" Author:  Jorengarenar <https://joren.ga>
" License: MIT

if exists('g:loaded_lcscope') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

augroup LCSCOPE
  autocmd!

  autocmd QuickFixCmdPre [^l]cscope
        \ let s:ccl = empty(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist'))

  autocmd QuickFixCmdPost [^l]cscope
        \ | copen
        \ | let s:qfcs = { "list": getqflist(), "title": w:quickfix_title }
        \ | wincmd p
        \ | silent! colder
        \ | if s:ccl | cclose | endif
        \ | call setloclist(0, s:qfcs.list)
        \ | call setloclist(0, [], 'a', { "title": s:qfcs.title })
        \ | lopen
        \ | unlet s:ccl s:qfcs

augroup END

let g:loaded_lcscope = 1
let &cpo = s:cpo_save | unlet s:cpo_save "
