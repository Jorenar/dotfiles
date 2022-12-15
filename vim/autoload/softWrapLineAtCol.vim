hi SoftWrapLineAtCol_Cursor ctermfg=bg ctermbg=fg
hi SoftWrapLineAtCol_Hidden ctermfg=bg ctermbg=bg
let s:cursorRefreshCmd = "match SoftWrapLineAtCol_Cursor '\\%.c\\%.l' | redraw"

call prop_type_add("softWrapLineAtCol", { "highlight": "SoftWrapLineAtCol_Hidden" })

augroup SOFT_WRAP_LINE_AT_COL
  autocmd!
augroup END

function! s:cleanUp(...)
  if !exists("s:pos")
    call win_execute(s:id, "let s:pos = getpos('.')")
    call setpos('.', s:pos)
  endif

  autocmd! SOFT_WRAP_LINE_AT_COL

  3match none
  call prop_clear(s:line, s:line, { "type": "softWrapLineAtCol" })
  redraw | echo

  unlet s:id s:line s:pos s:wincol s:stop s:tw
endfunction

function! s:popup() abort
  let s:line = line('.')

  let wininfo = getwininfo(win_getid())[0]
  let s:wincol = wininfo.wincol + wininfo.textoff

  let s:id = popup_create(bufnr(), {
        \   "line": 'cursor',
        \   "col": s:wincol,
        \   "firstline": s:line,
        \   "maxwidth": s:tw + 5,
        \   "maxheight": 2,
        \   "highlight": "Normal",
        \   "scrollbar": 0,
        \   "callback": "s:cleanUp",
        \ })

  call win_execute(s:id, "call setpos('.', " . string(getpos('.')) . ")")

  call setwinvar(s:id, "&lbr", &lbr)
  call setwinvar(s:id, "&bri", &bri)

  call setwinvar(s:id, "&spell", &spell)

  call autocmd_add([{
        \   "bufnr": bufnr(),
        \   "cmd": s:cursorRefreshCmd,
        \   "event": "TextChangedI",
        \   "group": "SOFT_WRAP_LINE_AT_COL",
        \ }])

  3match SoftWrapLineAtCol_Hidden /\%.l/

  echohl MoreMsg
  echo "-- WRAP LINE AT" (s:tw == &tw ? "&textwidth" : "COLUMN ".s:tw)  "--"
  echohl None
endfunction

function! s:height() abort
  let l:id = popup_create(getline(s:line), {
        \   "line": 'cursor',
        \   "col": s:wincol,
        \   "maxwidth": s:tw + 5,
        \   "scrollbar": 0,
        \   "highlight": "SoftWrapLineAtCol_Hidden",
        \   "visible": 0,
        \ })
  call setwinvar(l:id, "&lbr", &lbr)
  call setwinvar(l:id, "&bri", &bri)
  call win_execute(l:id, "redraw")
  let h = winheight(l:id)
  call popup_close(l:id)
  return h
endfunction

function! s:interations() abort
  let s:stop = 0
  let len_old = 0

  while line('.', s:id) == s:line && col('$') > s:tw * 1.1 && !s:stop
    if col('$') != len_old
      let h = s:height()
      call popup_move(s:id, { "maxheight": h })

      call prop_clear(s:line, s:line, { "type": "softWrapLineAtCol" })
      if line('$') >= s:line+1
        let h -= screenpos(0, s:line+1, 0).row - screenpos(0, s:line, 0).row
      endif
      for i in range(h)
        call prop_add(s:line, 0, {
              \   "type": "softWrapLineAtCol",
              \   "text_align": "below",
              \   "text": " ",
              \ })
      endfor
      let len_old = col('$')
    endif

    call win_execute(s:id, s:cursorRefreshCmd)

    let c = 0
    while type(c) == v:t_number
      let c = getcharstr(0)
    endwhile

    if c == "\<Esc>"
      let s:pos = 0 " don't change position in original window
      break
    endif

    if c =~ "[:?/]"
      continue
    endif

    let c = escape(c, '\')
    sil! call win_execute(s:id, "call feedkeys('" . c . "', 'cx!')")
  endwhile
endfunction

function! softWrapLineAtCol#toggle(width)
  if !exists("s:id")
    let s:tw = a:width
    call s:popup()
    call s:interations()
  endif
  let s:stop = 1
  call popup_close(s:id)
endfunction
