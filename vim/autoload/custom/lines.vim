function! s:VcsStats() abort " VCS stats; requires Signify plugin
  let sy = getbufvar(bufnr(), "sy")
  if empty(sy) | return "" | endif
  if !has_key(sy, "vcs") | return "" | endif
  let stats = map(sy.stats, 'v:val < 0 ? 0 : v:val')
  return printf("  [+%s -%s ~%s]", stats[0], stats[2], stats[1])
endfunction

function! s:CmpIssues(i1, i2) abort
  let F = {nr -> fnamemodify(bufname(nr), ':p:.')}
  let f1 = F(a:i1.bufnr)
  let f2 = F(a:i2.bufnr)
  if f1 != f2
    return f1 > f2 ? 1 : -1
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

  return 0
endfunction

function! s:GetQfCount(type) abort
  let issues = getloclist(0)
  let issues = filter(issues, 'v:val.type == "'.a:type.'"')
  let issues = uniq(issues, function("<SID>CmpIssues"))
  return len(issues).a:type
endfunction

function! s:IssuesCount() abort
  return s:GetQfCount("E")." ".s:GetQfCount("w")
endfunction

function! custom#lines#StatusLine() abort
  return ' '
      \ . "%{g:actual_curwin == win_getid() ? '>' : ' '}"
      \ . ' '
      \ . "[%{&mod ? '+' : (&ma ? '=' : '-')}]%r"
      \ . "  "
      \ . "%y"
      \ . "[".&ff.";".(&fenc == "" ? &enc : &fenc).(&bomb ? ",B" : "")."]"
      \ . "  "
      \ . "[%{".expand("<SID>")."IssuesCount()}]"
      \ . "%{".expand("<SID>")."VcsStats()}"
      \ . "  "
      \ . "%l/%L:%c"
      \ . "  |  "
      \ . "%<%f "
endfunction

function! custom#lines#TabLine() abort
  let l:tabline = ''

  for i in range(1, tabpagenr('$'))
    let l:tabline .= (i == tabpagenr()) ? '%#TabLineSel#' : '%#TabLine#'
    let l:tabline .= '%' . i . 'T'  " set the tab number (for mouse clicks)
    let l:tabline .= ' ' . i        " display tab number

    let tabname = gettabvar(i, "name")
    if !empty(tabname)
      let l:tabline .= ':' . tabname
    endif

    let l:tabline .= ' '
  endfor

  let l:tabline .= '%#TabLineFill#%T'
  let l:tabline .= '%=% '

  let tabwins = len(tabpagebuflist(tabpagenr()))
  let numbufs = len(getbufinfo({'buflisted':1})) " number of buffers
  let hidbufs = len(filter(getbufinfo({'buflisted':1}), 'empty(v:val.windows)'))

  let l:tabline .= "bufs: "
        \ . tabwins."/".(numbufs-hidbufs)."/".numbufs
        \ . " (+" . len(filter(getbufinfo(), 'v:val.changed')). ")"

  return l:tabline . ' '
endfunction
