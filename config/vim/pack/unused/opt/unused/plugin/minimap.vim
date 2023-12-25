" Minimap
" Author:  Jorengarenar <https://joren.ga>
" License: MIT

if exists('g:loaded_minimap') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

let g:minimap_width = get(g:, "minimap_width", 20)

hi! default link Minimap Visual

let s:minimap = 0
let s:pixels = [
      \   [ 0x1,  0x8  ],
      \   [ 0x2,  0x10 ],
      \   [ 0x4,  0x20 ],
      \   [ 0x40, 0x80 ]
      \ ]

function! s:move() abort
  let topline = line("w0")
  let bottomline = line("w$")
  let top = (topline - 1) / 4
  let bottom = (bottomline - 1) / 4 + 2
  call win_execute(s:minimap, 'match Minimap /\v%>'.top.'l%<'.bottom.'l./')
  if line("$", s:minimap) > winheight(s:minimap)
    call win_execute(s:minimap, "normal! ".((top + bottom)/2)."ggzz")
  endif
endfunction

function! MinimapUpdate() abort
  if !s:minimap | return | endif

  let scale = s:width / (&l:tw * 1.2)
  let canvas = map(range(line("$")*4 * s:width*2), 0)

  let y = 1
  for linestr in getline(y, "$")
    for x in range(2 * min([float2nr(len(linestr) * scale), s:width]))
      if x >= float2nr(indent(y) * scale)
        let col = x / 2
        let row = y / 4
        let mask = s:pixels[y % 4][x % 2]
        let idx = row*s:width*2 + col
        let canvas[idx] = or(canvas[idx], mask)
      endif
    endfor
    let y += 1
  endfor

  let result = []
  for y in range(line("$")+1)
    let row = ""
    for x in range(s:width+1)
      let idx = y*s:width*2 + x
      let char = canvas[idx]
      let row .= char ? nr2char(0x2800+char) : ' '
    endfor
    let result += [row]
  endfor

  let buf = winbufnr(s:minimap)
  silent! call deletebufline(buf, 1, "$")
  silent! call setbufline(buf, 1, result)

  call s:move()
endfunction

function! MinimapInit() abort
  if !s:minimap
    let s:width = g:minimap_width
    exec "botright" s:width."vnew"
    setlocal winfixwidth

    let s:minimap = win_getid()

    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    setlocal nonumber norelativenumber nolist nospell nowrap signcolumn=no
    setlocal stl=\ Minimap
    setlocal mouse=a

    augroup MINIMAP
      autocmd!
      autocmd WinEnter <buffer> if winnr("$") == 1 | quit | endif
      autocmd WinEnter <buffer> wincmd p
      autocmd WinClosed <buffer> let s:minimap = 0 | autocmd! MINIMAP
      autocmd TextChanged,VimResized,BufWinEnter,WinEnter * call MinimapUpdate()
      autocmd CursorMoved,CursorMovedI * call <SID>move()
    augroup END

    wincmd p
  endif

  call MinimapUpdate()
endfunction

function! MinimapClose() abort
  if !s:minimap | return | endif
  call win_execute(s:minimap, "quit")
endfunction

command! Minimap exec "call Minimap".(s:minimap ? "Close()" : "Init()")

let g:loaded_minimap = 1
let &cpo = s:cpo_save | unlet s:cpo_save
