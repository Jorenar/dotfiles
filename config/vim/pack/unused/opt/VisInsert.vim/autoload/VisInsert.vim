" VisInsert
" Author:  Jorenar
" License: MIT

function! s:repeat() abort
  let [ ve_old, &l:ve ] = [ &l:ve, "all" ]
  let [ bs_old, &bs ] = [ &bs, 'indent,start' ]

  let et_save = &l:et
  let [ paste_old, &paste ] = [ &paste, 1 ]
  let &l:et = et_save

  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]

  let col = (@s =~# '^\d*a') ? column_end : column_start
  for l in range(line_start+1, line_end)
    call setpos('.', [0, l, col, 0])
    norm! @s
  endfor

  call setpos('.', [0, line_start, column_start, 0])

  let [ &l:ve, &bs, &paste, @s ] = [ ve_old, bs_old, paste_old, s:s_old ]
endfunction

function! VisInsert#start(k) abort
  exec "norm! \<Esc>`<"
  if a:k =~# '\d*a'
    call setpos('.', [0, line('.'), getpos("'>")[2], 0])
  endif

  autocmd InsertLeave * ++once exec "norm! q" | call <SID>repeat()

  let [ @s, s:s_old ] = [ a:k, @s ] | norm! qS
  call feedkeys(a:k, 'n')
endfunction
