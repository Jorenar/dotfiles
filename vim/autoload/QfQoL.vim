function! QfQoL#cmp(i1, i2, ...) abort
  let igr = get(a:, 1, '')

  if igr !~# 't'
    let t1 = a:i1.type
    let t2 = a:i2.type
    if t1 != t2
      return
            \   t1 == 'E' ? -1
            \ : t2 == 'E' ?  1
            \ : t1 == 'W' ? -1
            \ : t2 == 'W' ?  1
            \ : t1 ># t2 ? 1 : -1
    endif
  endif

  if igr !~# 'f'
    let F = {nr -> fnamemodify(bufname(nr), ':p:.')}
    let f1 = F(a:i1.bufnr)
    let f2 = F(a:i2.bufnr)
    if f1 !=# f2
      return f1 ># f2 ? 1 : -1
    endif
  endif

  if igr !~# 'l'
    let lnum1 = a:i1.lnum
    let lnum2 = a:i2.lnum
    if lnum1 != lnum2
      return lnum1 > lnum2 ? 1 : -1
    endif
  endif

  if igr !~# 'c'
    let col1 = a:i1.col
    let col2 = a:i2.col
    if col1 != col2
      return col1 > col2 ? 1 : -1
    endif
  endif

  if igr !~# 'T'
    let T1 = a:i1.text
    let T2 = a:i2.text
    if T1 !=# T2
      return T1 ># T2 ? 1 : -1
    endif
  endif

  return 0
endfunction

function! QfQoL#sort(opts) abort
  if w:QfQoL_isLocList
    let list = getloclist(0, {'all': 0})
    let Set = {l -> setloclist(0, [], ' ', l)}
  else
    let list = getqflist({'all': 0})
    let Set = {l -> setqflist([], ' ', l)}
  endif

  let list.items = sort(list.items, get(g:, "QfQoL_cmp_func", 'QfQoL#cmp'))

  if a:opts =~ 'u'
    let list.items = uniq(list.items)
  endif

  call Set(list)
endfunction
