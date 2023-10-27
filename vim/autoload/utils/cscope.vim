function! utils#cscope#init() abort
  let [ csverb_old, &cscopeverbose ] = [ &cscopeverbose, 0 ]

  let l:dbpath = fnamemodify(finddir(".tags", ";"), ":p")
  let l:root = fnamemodify(l:dbpath, ':p:h:h')

  let l:csdb = fnamemodify(l:dbpath, ':p') . "cscope.out"
  if filereadable(l:csdb)
    exec "cs add" l:csdb
  elseif filereadable("cscope.out")
    cs add cscope.out
  else
    let l:csdb = ""
  endif

  if executable("gtags-cscope")
    if empty($GTAGSROOT)   | let $GTAGSROOT   = l:root   | endif
    if empty($GTAGSDBPATH) | let $GTAGSDBPATH = l:dbpath | endif

    set cscopeprg=gtags-cscope

    let l:db = fnamemodify($GTAGSDBPATH, ':p') . "GTAGS"

    if filereadable(l:db)
      exec "cs add" l:db
    endif
  endif

  let &cscopeverbose = csverb_old
endfunction
