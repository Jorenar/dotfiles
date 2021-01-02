" fauxClip - Clipboard support without +clipboard
" Maintainer:  Jorengarenar <https://joren.ga>

function! fauxClip#start(REG)
  let s:REG = a:REG
  let s:reg = [getreg('"'), getregtype('"')]

  let @@ = fauxClip#paste(s:REG)

  augroup fauxClip
    autocmd!
    if exists('##TextYankPost')
      autocmd TextYankPost * if v:event.regname == '"' | call fauxClip#yank(v:event.regcontents) | endif
    else
      autocmd CursorMoved  * if @@ != s:reg | call fauxClip#yank(@@) | endif
    endif
    autocmd TextChanged  * call fauxClip#end()
  augroup END

  return '""'
endfunction

function! fauxClip#yank(content)
  if s:REG == "+"
    call system(g:fauxClip_copy_cmd, a:content)
  else
    call system(g:fauxClip_copy_primary_cmd, a:content)
  endif

  call fauxClip#end()
endfunction

function! fauxClip#paste(REG)
  if a:REG == "+"
    return system(g:fauxClip_paste_cmd)
  else
    return system(g:fauxClip_paste_primary_cmd)
  endif
endfunction

function! fauxClip#end()
  augroup fauxClip
    autocmd!
  augroup END
  call setreg('"', s:reg[0], s:reg[1])
  unlet! s:reg s:REG
endfunction

function! fauxClip#cmd(cmd, REG) range
  let s:REG = a:REG
  let s:reg = [getreg('"'), getregtype('"')]
  if a:cmd =~# 'pu\%[t]'
    execute a:firstline . ',' . a:lastline . a:cmd ."=fauxClip#paste(s:REG)"
    call fauxClip#end()
  else
    execute a:firstline . ',' . a:lastline . a:cmd
    call fauxClip#yank(getreg('"'))
  endif
endfunction

function! fauxClip#restore_CR()
  if empty(g:CR_old)
    cunmap <CR>
  else
    execute   (g:CR_old["noremap"] ? "cnoremap " : "cmap ")
          \ . (g:CR_old["silent"]  ? "<silent> " : "")
          \ . (g:CR_old["nowait"]  ? "<nowait> " : "")
          \ . (g:CR_old["expr"]    ? "<expr> "   : "")
          \ . (g:CR_old["buffer"]  ? "<buffer> " : "")
          \ . g:CR_old["lhs"]." ".g:CR_old["rhs"]
  endif
  unlet g:CR_old
endfunction

function! fauxClip#cmd_pattern()
  return '\v%(%(^|\|)\s*%(\%|\d\,\d|' . "'\\<\\,'\\>" . ')?\s*)@<=(y%[ank]|d%[elete]|pu%[t]!?)\s*([+*])'
endfunction

function! fauxClip#CR()
  call histadd(":", getcmdline())
  return substitute(getcmdline(),
        \ fauxClip#cmd_pattern(),
        \ 'call fauxClip#cmd(''\1'', ''\2'')', 'g')
        \ . " | call histdel(':', -1)"
endfunction
