function! s:TabLabels() abort
  let l:tabline = ''

  let TabLabel = {n -> bufname(tabpagebuflist(n)[tabpagewinnr(n) - 1])}
  let l:TabLabels = map(range(tabpagenr("$")), 'TabLabel(v:val+1)')
  let l:labelsLenghts = map(deepcopy(l:TabLabels), 'len(v:val)+2')
  let ReduceLen = {st,ed -> reduce(l:labelsLenghts[st:ed], {a,b -> a+b+10})}

  let l:last = tabpagenr('$')
  let l:cur = tabpagenr()-1

  let l:st = 0
  while ReduceLen(l:st, l:cur) > &columns
    let l:st += 1
  endwhile

  let l:ed = l:cur+1 < l:last ? l:cur+1 : l:cur
  while l:ed < l:last-1 && ReduceLen(l:st, l:ed+1) < &columns
    let l:ed += 1
  endwhile

  for i in range(l:st+1, l:ed+1)
    let l:tabline .= i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
    let l:tabline .= '%' . i . 'T'   " set the tab page number (for mouse clicks)
    let l:tabline .= ' T' . i . ' '  " display tab page number
    let l:tabline .= tabpagewinnr(i, '$') . ' '
    if !empty(l:TabLabels[i-1])
      let l:tabline .= '['.l:TabLabels[i-1] . '] '
    endif
  endfor

  let l:tabline .= '%#TabLineFill#%T'
  let l:tabline .= '%=%'

  return l:tabline
endfunction

function! lines#VcsStats() abort " VCS stats; requires Signify plugin
  let sy = getbufvar(bufnr(), "sy")
  if empty(sy) | return "" | endif
  if !has_key(sy, "vcs") | return "" | endif
  let stats = map(sy.stats, 'v:val < 0 ? 0 : v:val')
  return printf("  [+%s -%s ~%s]", stats[0], stats[2], stats[1])
endfunction

function! lines#IssuesCount() abort
  let errors   = len(filter(getloclist(0), 'v:val.type == "E"'))
  let warnings = len(filter(getloclist(0), 'v:val.type == "w"'))
  return errors."E ".warnings."w"
endfunction

function! lines#TabLine() abort
  let num = len(getbufinfo({'buflisted':1})) " number of buffers
  let hid = len(filter(getbufinfo({'buflisted':1}), 'empty(v:val.windows)'))

  return ''
        \ . '['
        \   . (num-hid)."/".num
        \   . ' '
        \   .  "+" . len(filter(getbufinfo(), 'v:val.changed'))
        \ . ']'
        \ . '  '
        \ . s:TabLabels()
endfunction

function! lines#StatusLine() abort
  return ' '
      \ . "[%{&mod ? '+' : (&ma ? '=' : '-')}]%r"
      \ . "  "
      \ . "%y"
      \ . "[".&ff.";".(&fenc == "" ? &enc : &fenc).(&bomb ? ",B" : "")."]"
      \ . "  "
      \ . "[%{lines#IssuesCount()}]"
      \ . "%{lines#VcsStats()}"
      \ . "  "
      \ . "%l/%L:%c"
      \ . "  |  "
      \ . "%<%f "
endfunction
