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

  let pad = 0
  for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
    let e = qfl[idx]
    let f = fnamemodify(bufname(e.bufnr), ':p:.')
    let t = empty(e.type) ? '' : ' ['.e.type.']'
    let p = printf('%s %s:%d:%d', t, f, e.lnum, e.col)
    call add(items, [ p, e.text ])
    let pad = len(p) > pad ? len(p) : pad
  endfor

  return map(items, 'printf("%-*s  %s", pad, v:val[0], v:val[1])')
endfunction
