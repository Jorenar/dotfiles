function! custom#texts#FoldText() abort
  let w = float2nr(&tw/2.5)

  let line = getline(v:foldstart)
  let line = substitute(line, '\t', repeat(' ', &ts), 'g')
  let line = substitute(line, split(&l:fmr, ',')[0].'\d\?', '', '')
  let line = trim(line, " \t\r\n", 2)
  let line = strchars(line)-3 > w ? line[:w] . "..." : line

  return printf("%s  +%s %d lines ",
        \ line,
        \ repeat(v:folddashes, 2),
        \ v:foldend - v:foldstart + 1)
endfunction

function! custom#texts#QuickFixTextFunc(info) abort
  let qfl = a:info.quickfix
        \ ? getqflist({'id': a:info.id, 'items': 0}).items
        \ : getloclist(a:info.winid, {'id': a:info.id, 'items': 0}).items

  let items = []

  let pad_p = 0
  let pad_t = 0

  for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
    let e = qfl[idx]

    let t = empty(e.type) ? '' : ' ['.e.type.']'
    let f = fnamemodify(bufname(e.bufnr), ':p:.')
    let T = e.text

    let p = ""
    if !empty(f) && e.lnum
      let p = printf('%s:%d  ', f, e.lnum)
      let p = e.col ? printf('%s:%d  ', p, e.col) : p."  "
      let T = trim(T)
    endif

    call add(items, [ t, p, T ])

    let pad_t = len(t) > pad_t ? len(t) : pad_t
    let pad_p = len(p) > pad_p ? len(p) : pad_p
  endfor

  return map(items,
        \ 'printf("%-*s %-*s %s",
        \         pad_t, v:val[0],
        \         pad_p, v:val[1],
        \         v:val[2])')
endfunction
