function! utils#qf#cmp(i1, i2, ...) abort
  let cmpText = get(a:, 1, 1)

  let F = {nr -> fnamemodify(bufname(nr), ':p:.')}
  let f1 = F(a:i1.bufnr)
  let f2 = F(a:i2.bufnr)
  if f1 !=# f2
    return f1 ># f2 ? 1 : -1
  endif

  let lnum1 = a:i1.lnum
  let lnum2 = a:i2.lnum
  if lnum1 != lnum2
    return lnum1 > lnum2 ? 1 : -1
  endif

  let col1 = a:i1.col
  let col2 = a:i2.col
  if col1 != col2
    return col1 > col2 ? 1 : -1
  endif

  if cmpText
    let t1 = a:i1.text
    let t2 = a:i2.text
    if t1 !=# t2
      return t1 ># t2 ? 1 : -1
    endif
  endif

  return 0
endfunction

function! utils#qf#sort(fn) abort
  if w:is_loclist
    let list = getloclist(0, {'all': 0})
    let list.items = sort(list.items, a:fn)
    call setloclist(0, [], 'r', list)
  else
    let list = getqflist({'all': 0})
    let list.items = sort(list.items, a:fn)
    call setqflist([], 'r', list)
  endif
endfunction
