function! s:Vcs() abort " VCS stats; requires Signify plugin
  let stats = getbufvar(bufnr(), 'sy', {})
        \ ->get('stats', ['?','?','?'])->deepcopy()
        \ ->map('v:val < 0 ? "0" : v:val')
  return printf('+%s -%s ~%s', stats[0], stats[2], stats[1])
endfunction

function! s:GetQfCount(type) abort
  let l:type = a:type == 'I' ? '[IN]' : a:type
  let issues = getloclist(0)
        \ ->filter({_,v -> v.type =~ l:type})
        \ ->uniq({i1,i2 -> QfQoL#cmp(i1, i2, 'T')})
  return len(issues).a:type
endfunction

function! s:QfIssues() abort
  return [ 'E', 'W', 'I' ]->map('s:GetQfCount(v:val)')->join(' ')
endfunction

function! s:FileInfo()
  return ''
        \ . (empty(&ft) ? '' : &ft.';')
        \ . (#{ dos:'CRLF', unix:'LF', mac:'CR' }[&ff] . ',')
        \ . (empty(&fenc) ? &enc : &fenc)
        \ . (&bomb ? ',B' : '')
endfunction

function! s:Path() abort
  let path = expand('%:.')
  if empty(path) | return '[No Name]' | endif
  let scheme = matchstr(path, '^\w\+://')
  let path = path[len(scheme):]
  return scheme . pathshorten(path)
endfunction

function! s:CurPos() abort
  const ln = line('$')
  return printf('%0*d/%d:%02d', len(ln), line('.'), ln, col('.'))
endfunction

function! utils#lines#StatusLine() abort
  return ''
      \ . "[%{&mod ? '+' : (&ma ? '=' : '-')}%R] "
      \ . [ 'Path', 'CurPos', 'QfIssues', 'Vcs', 'FileInfo' ]
      \     ->map({_,v -> '%{'.expand('<SID>').v.'()}'})->join(' | ')
      \ . '%<'
endfunction


function! utils#lines#TabLine() abort
  let tabline = ''

  let numbufs = len(getbufinfo({'buflisted':1})) " number of buffers
  let hidbufs = len(filter(getbufinfo({'buflisted':1}), 'empty(v:val.windows)'))

  let tabline .= '['
        \ . (numbufs-hidbufs).'/'.numbufs.'/'
        \ . '+'.len(filter(getbufinfo(), 'v:val.changed'))
        \ . '] '

  for i in range(1, tabpagenr('$'))
    let tabline .= (i == tabpagenr()) ? '%#TabLineSel#' : '%#TabLine#'
    let tabline .= '%' . i . 'T'  " set the tab number (for mouse clicks)
    let tabline .= ' ' . i        " display tab number

    let tabname = gettabvar(i, 'name')
    if !empty(tabname)
      let tabline .= ':' . tabname
    endif

    let tabline .= ' '
  endfor
  let tabline .= '%#TabLineFill#'

  return tabline . ' '
endfunction
