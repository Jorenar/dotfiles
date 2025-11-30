" TermCmdHack
" Description: Vim's behaviour of :term command
" Author: Jorenar
" License: MIT

if exists('g:loaded_TermCmdHack') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

let s:cli_pattern = '\v\C%(^|\|)\s*\zs(te%[rminal]!?)\ze%($|\s)'

function! s:cli_set_CR() abort
  let s:CR_old = get(s:, 'CR_old', maparg('<CR>', 'c', '', 1))
  cnoremap <expr><silent> <CR> <SID>cli_check() ?
        \ '<C-e><C-u>'.<SID>cli_CR().'<CR><Cmd>call histdel(":", -1)<CR>' : '<CR>'
endfunction

function! s:cli_restore_CR() abort
  if empty(s:CR_old)
    cunmap <CR>
  else
    call mapset(s:CR_old)
  endif
  unlet s:CR_old
endfunction

function! s:cli_CR() abort
  call s:cli_restore_CR()
  call histadd(":", getcmdline())
  return substitute(getcmdline(), s:cli_pattern, 'hor \1', 'g')
endfunction

function! s:cli_check() abort
  return getcmdline() =~# s:cli_pattern
endfunction

autocmd CmdlineChanged :
      \  if <SID>cli_check()
      \|   call <SID>cli_set_CR()
      \| elseif exists('<SID>CR_old')
      \|   call <SID>cli_restore_CR()
      \| endif

let g:loaded_TermCmdHack = 1
let &cpo = s:cpo_save | unlet s:cpo_save
