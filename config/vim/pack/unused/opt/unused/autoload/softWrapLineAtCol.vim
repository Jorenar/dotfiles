hi SWLAC_cursor ctermfg=bg ctermbg=fg
hi SWLAC_hidden ctermfg=bg ctermbg=bg cterm=NONE

let s:cursorRefreshCmd = "match SWLAC_cursor '\\%.c' | redraw"

let s:cursorState = 1
let s:cursorBlinkTime = 0

call prop_type_add("SWLAC_padding", { "highlight": "SWLAC_hidden" })

augroup SOFT_WRAP_LINE_AT_COL
  autocmd!
augroup END

function! s:cleanUp(...)
  if !exists("s:pos")
    call win_execute(s:id, "let s:pos = getpos('.')")
    call setpos('.', s:pos)
  endif

  autocmd! SOFT_WRAP_LINE_AT_COL

  call win_execute(s:parentWinId, "2match none")
  call prop_clear(s:line, s:line, { "type": "SWLAC_padding" })
  redraw | echo

  unlet s:id s:parentWinId s:line s:pos s:stop s:tw s:t_ve
endfunction

function! s:popup() abort
  let s:line = line('.')
  let s:t_ve = &t_ve
  let s:parentWinId = win_getid()

  let wininfo = getwininfo(s:parentWinId)[0]

  let s:id = popup_create(bufnr(), {
        \   "line": 'cursor',
        \   "col": wininfo.wincol + wininfo.textoff,
        \   "firstline": s:line,
        \   "maxwidth": min([s:tw + 5, wininfo.width - wininfo.textoff]),
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
        \   "event": [ "TextChangedI", "CursorMovedI", "InsertEnter" ],
        \   "group": "SOFT_WRAP_LINE_AT_COL",
        \ }])

  call autocmd_add([{
        \   "bufnr": bufnr(),
        \   "cmd":  "let &t_ve = col('.') >= col('$') ? s:t_ve : ''",
        \   "event": [ "InsertEnter", "CursorMovedI" ],
        \   "group": "SOFT_WRAP_LINE_AT_COL",
        \ }])

  call autocmd_add([{
        \   "bufnr": bufnr(),
        \   "cmd": "let &t_ve = s:t_ve",
        \   "event": [ "InsertLeave" ],
        \   "group": "SOFT_WRAP_LINE_AT_COL",
        \ }])
endfunction

function! s:cursorBlink(f) abort
  if !s:cursorState || a:f
    hi SWLAC_cursor ctermfg=bg ctermbg=fg
  else
    hi SWLAC_cursor ctermfg=fg ctermbg=bg
  endif
  let s:cursorState = !s:cursorState + a:f
endfunction

function! s:slineHeight(winid) abort
  let h = screenpos(a:winid, s:line, col('$', a:winid)).row
  if h >= 1
    let h -= screenpos(a:winid, s:line, 1).row
  endif
  return h + 1
endfunction

function! s:redoHeight() abort
  let h = 0
  if s:line < line('$')
    call win_execute(s:id, "redraw")
    let h = s:slineHeight(s:id)

    call prop_clear(s:line, s:line, { "type": "SWLAC_padding" })
    for i in range(h - s:slineHeight(s:parentWinId))
      call prop_add(s:line, 0, {
            \   "type": "SWLAC_padding",
            \   "text_align": "below",
            \   "text": " ",
            \ })
    endfor
  endif

  call popup_move(s:id, { "maxheight": h })
endfunction

function! s:getChar() abort
  while 1
    let c = getcharstr(0)
    if !empty(c)
      call s:cursorBlink(1)
      return c
    endif

    if localtime() - s:cursorBlinkTime >= 1
      call s:cursorBlink(0)
      call win_execute(s:id, s:cursorRefreshCmd)
      let s:cursorBlinkTime = localtime()
    endif
  endwhile
endfunction

function! s:interations() abort
  let s:stop = 0
  let len_old = 0

  if line('.') != s:line || win_getid() != s:parentWinId
    let s:pos = 0
    return 0
  endif

  while line('.', s:id) == s:line && col('$', s:id) > s:tw * 1.1 && !s:stop
    if col('$') != len_old
      call s:redoHeight()
      let len_old = col('$')
    endif

    silent! call win_execute(s:id, s:cursorRefreshCmd)

    let c = s:getChar()

    if c == "\<Esc>"
      let s:pos = 0 " don't change position in original window
      return 0
    elseif c =~ "[:?/]"
      return c
    else
      sil! call win_execute(s:id, "call feedkeys('" . escape(c, '\') . "', 'cx!')")
    endif
  endwhile
endfunction

function! softWrapLineAtCol#toggle(width)
  if exists("s:id")
    let s:stop = 1
    return
  endif

  let s:tw = a:width

  if col('$') < s:tw * 1.1 | return | endif

  call s:popup()

  2match SWLAC_hidden /\%.l/

  echohl MoreMsg
  echo "-- WRAP LINE AT" (s:tw == &tw ? "&textwidth" : "COLUMN ".s:tw)  "--"
  echohl None

  while 1
    let c = s:interations()
    if type(c) == v:t_number
      break
    endif
    call feedkeys(c, 'cx!')
  endwhile

  call popup_close(s:id)
endfunction
