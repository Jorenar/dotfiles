let s:cursor = "match FooCursor '\\%.c\\%.l' | redraw"

hi FooCursor ctermfg=bg ctermbg=fg

augroup WRAPATPOPUP
  autocmd!
augroup END

function! s:cleanUp(...)
  call win_execute(s:id, "let s:pos = getpos('.')")
  call setpos('.', s:pos)

  unlet s:id s:pos
  autocmd! WRAPATPOPUP
endfunction

function! s:popup() abort
  let s:id = popup_create(bufnr(), {
        \   "line": 'cursor+1',
        \   "col": &numberwidth + 2,
        \   "firstline": 'cursor',
        \   "border": [],
        \   "maxwidth": &tw + 5,
        \   "highlight": "Normal",
        \   "scrollbar": 0,
        \   "callback": "s:cleanUp",
        \ })

  call win_execute(s:id, "call setpos('.', " . string(getpos('.')) . ")")

  call autocmd_add([{
        \   "bufnr": bufnr(),
        \   "cmd": s:cursor,
        \   "event": "TextChangedI",
        \   "group": "WRAPATPOPUP",
        \ }])

  call setwinvar(s:id, "&lbr", &lbr)
  call setwinvar(s:id, "&bri", &bri)

  call setwinvar(s:id, "&spell", 0)
endfunction

function! s:interations() abort
  let curline = line('.')

  let Height = { -> float2nr(ceil(
        \   (col('$')*1.0 + len(&sbr)) / ( &tw - len(&sbr) - indent('.') ) - 0.1
        \ )) }

  while line('.', s:id) == curline
    call popup_move(s:id, { "maxheight": Height() })
    call win_execute(s:id, s:cursor)

    let c = 0
    while c == 0
      let c = getchar(0)
    endwhile

    let c = nr2char(c)

    if c == "\<Esc>"
      break
    endif

    if c =~ "[:?/]"
      redraw
      echo "Not available here"
      continue
    endif

    sil! call win_execute(s:id, 'call feedkeys("' . escape(c,'\') . '", "x!")')
  endwhile

  call popup_close(s:id)
endfunction

function! wrapAtPopup#toggle()
  if exists("s:id")
    call popup_close(s:id)
    return
  endif

  let text = trim(getline('.'), " ", 2)
  if len(text) <= &tw * 1.1 | return | endif

  call s:popup()
  call s:interations()
endfunction
