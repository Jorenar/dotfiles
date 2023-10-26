function! unused#upper(k)
  if synIDattr(synID(line('.'), col('.')-1, 0), "name") !~# 'Comment\|String'
    return toupper(a:k)
  else
    return a:k " was comment or string, so don't change case
  endif
endfunction

function! unused#TermEF(cmd) abort
  let errorsfile = tempname()

  let cmd  = expandcmd(a:cmd)
  let cmd .= " 2>&1 "
  let cmd .= has('nvim') ? "\\|" : "\|"
  let cmd .= " tee ".errorsfile

  if has('nvim')
    execute "term://".cmd
    augroup OPEN_ERROR_FILE
      autocmd!
      autocmd TermOpen  <buffer> let b:term_job_finished = 0
      autocmd TermEnter <buffer> if  b:term_job_finished | call feedkeys("\<C-\>\<C-n>") | endif
      execute "autocmd TermLeave <buffer> if !b:term_job_finished | cfile ".errorsfile." | endif"

      execute 'autocmd TermClose <buffer> let b:term_job_finished = 1 | call feedkeys("\<C-\>\<C-n>") | cfile '. errorsfile .' | copen'
    augroup END
  else
    tabe
    call term_start([ &shell, '-c', expandcmd(cmd) ], #{
          \   curwin:  1,
          \   exit_cb: { -> execute("cfile ".errorsfile." | cwindow") },
          \ })
  endif

  setlocal switchbuf=usetab
endfunction

function! unused#CountSpell() abort
  let [ pos, spell_old, ws_old, lz_old ] = [ getpos('.'), &spell, &ws, &lz ]
  let [ &spell, &ws, &lz ] = [ 1, 0, 1 ]

  let [ counter, prev_pos ] = [ 0, pos ]
  normal! gg0

  while 1
    normal! ]S
    if getpos(".") == prev_pos | break | endif
    let [ counter, prev_pos ] = [ counter+1, getpos('.') ]
  endwhile

  call setpos('.', pos)
  let [ &spell, &ws, &lz ] = [ spell_old, ws_old, lz_old ]

  return counter
endfunction
