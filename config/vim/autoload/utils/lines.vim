function! s:VcsStats(l,r) abort " VCS stats; requires Signify plugin
  let sy = getbufvar(bufnr(), 'sy')
  if empty(sy) | return '' | endif
  if !has_key(sy, 'vcs') | return '' | endif
  let stats = map(sy.stats, 'v:val < 0 ? 0 : v:val')
  return printf(a:l.'+%s -%s ~%s'.a:r, stats[0], stats[2], stats[1])
endfunction

function! s:GetQfCount(type) abort
  let issues = getloclist(0)
  let issues = filter(issues, {_,v -> v.type == a:type})
  let issues = uniq(issues, {i1,i2 -> QfQoL#cmp(i1, i2, 'T')})
  return len(issues).a:type
endfunction

function! s:IssuesCount() abort
  return s:GetQfCount('E').' '.s:GetQfCount('w').' '.s:GetQfCount('I')
endfunction

function! s:GetFF()
  let ff = { 'dos': 'CRLF', 'unix': 'LF', 'mac': 'CR' }[&fileformat]
  let fe = empty(&fenc) ? &enc : &fenc
  return ff . ';' . fe . (&bomb ? ',B' : '')
endfunction

function! utils#lines#StatusLine() abort
  return ''
      \ . "[%{&mod ? '+' : (&ma ? '=' : '-')}%R]"
      \ . ' %t %l/%L:%c |'
      \ . ' %{'.expand('<SID>').'IssuesCount()}'
      \ . ' %{'.expand('<SID>').'VcsStats("| ", "")}'
      \ . ' %=%< %y[%{'.expand('<SID>').'GetFF()}]'
endfunction

function! utils#lines#TabLine() abort
  let l:tabline = ''

  for i in range(1, tabpagenr('$'))
    let l:tabline .= (i == tabpagenr()) ? '%#TabLineSel#' : '%#TabLine#'
    let l:tabline .= '%' . i . 'T'  " set the tab number (for mouse clicks)
    let l:tabline .= ' ' . i        " display tab number

    let tabname = gettabvar(i, 'name')
    if !empty(tabname)
      let l:tabline .= ':' . tabname
    endif

    let l:tabline .= ' '
  endfor

  let l:tabline .= '%#TabLineFill#%T'
  let l:tabline .= '%=% '

  let l:tabline .= '%f%= '

  " let tabwins = len(tabpagebuflist(tabpagenr()))
  " let numbufs = len(getbufinfo({'buflisted':1})) " number of buffers
  " let hidbufs = len(filter(getbufinfo({'buflisted':1}), 'empty(v:val.windows)'))

  " let l:tabline .= 'bufs: '
  "       \ . tabwins.'/'.(numbufs-hidbufs).'/'.numbufs
  "       \ . ' (+' . len(filter(getbufinfo(), 'v:val.changed')). ')'

  return l:tabline . ' '
endfunction
