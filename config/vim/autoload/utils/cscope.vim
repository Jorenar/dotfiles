function! utils#cscope#init() abort
  if has('cscope')
    let [ csverb_old, &cscopeverbose ] = [ &cscopeverbose, 0 ]
    let l:CsAdd = 'cs add'
  elseif has('nvim')
    let l:CsAdd = 'Cs db add'
  else
    return
  endif

  let l:dbpath = fnamemodify(finddir('.tags', ';'), ':p')
  let l:root = fnamemodify(l:dbpath, ':p:h:h')

  let l:csdb = fnamemodify(l:dbpath, ':p') . 'cscope.out'
  if filereadable(l:csdb)
    exec l:CsAdd l:csdb
  elseif filereadable('cscope.out')
    exec l:CsAdd 'cscope.out'
  endif

  if executable('gtags-cscope')
    if empty($GTAGSROOT)   | let $GTAGSROOT   = l:root   | endif
    if empty($GTAGSDBPATH) | let $GTAGSDBPATH = l:dbpath | endif

    set cscopeprg=gtags-cscope

    let l:db = fnamemodify($GTAGSDBPATH, ':p') . 'GTAGS'

    if filereadable(l:db)
      exec l:CsAdd l:db
    endif
  endif

  if has('cscope') | let &cscopeverbose = csverb_old | endif
endfunction
