hi SWLAC_cursor ctermfg=bg ctermbg=fg
hi SWLAC_hidden ctermfg=bg ctermbg=bg
let s:cursorRefreshCmd = "match SWLAC_cursor '\\%.c' | redraw"

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

  3match none
  call prop_clear(s:line, s:line, { "type": "SWLAC_padding" })
  redraw | echo

  let &t_ve = s:t_ve

  unlet s:id s:line s:pos s:wincol s:stop s:tw
endfunction

function! s:popup() abort
  let s:line = line('.')
  let [ s:t_ve, &t_ve ] = [ &t_ve, "" ]

  let wininfo = getwininfo(win_getid())[0]
  let s:wincol = wininfo.wincol + wininfo.textoff

  let s:id = popup_create(bufnr(), {
        \   "line": 'cursor',
        \   "col": s:wincol,
        \   "firstline": s:line,
        \   "maxwidth": s:tw + 5,
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
        \   "cmd": "let &t_ve = s:t_ve",
        \   "event": [ "CmdlineEnter" ],
        \   "group": "SOFT_WRAP_LINE_AT_COL",
        \ }])

  call autocmd_add([{
        \   "bufnr": bufnr(),
        \   "cmd": "let &t_ve = ''",
        \   "event": [ "CmdlineLeave" ],
        \   "group": "SOFT_WRAP_LINE_AT_COL",
        \ }])
endfunction

function! s:slineHeight(winid) abort
  let h = screenpos(a:winid, s:line, col('$', a:winid)).row
  if h
    let h -= screenpos(a:winid, s:line, 1).row
  endif
  return h + 1
endfunction

function! s:interations() abort
  let s:stop = 0
  let len_old = 0

  if line('.') != s:line
    let s:pos = 0
    return 0
  endif

  while line('.', s:id) == s:line && col('$') > s:tw * 1.1 && !s:stop
    if col('$') != len_old
      let h = 0
      if s:line < line('$')
        call win_execute(s:id, "redraw")
        let h = s:slineHeight(s:id)

        call prop_clear(s:line, s:line, { "type": "SWLAC_padding" })
        for i in range(h - s:slineHeight(0))
          call prop_add(s:line, 0, {
                \   "type": "SWLAC_padding",
                \   "text_align": "below",
                \   "text": " ",
                \ })
        endfor
      endif

      call popup_move(s:id, { "maxheight": h })
      let len_old = col('$')
    endif

    call win_execute(s:id, s:cursorRefreshCmd)

    let c = getcharstr()

    if c == "\<Esc>"
      let s:pos = 0 " don't change position in original window
      break
    endif

    if c =~ "[:?/]"
      return c
    endif

    let c = escape(c, '\')
    sil! call win_execute(s:id, "call feedkeys('" . c . "', 'cx!')")
  endwhile

  return 0
endfunction

function! softWrapLineAtCol#toggle(width)
  if exists("s:id")
    let s:stop = 1
    return
  endif

  let s:tw = a:width

  if col('$') < s:tw * 1.1 | return | endif

  call s:popup()

  3match SWLAC_hidden /\%.l/

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
