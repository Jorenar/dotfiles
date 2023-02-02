function! s:handleDups() abort
  copen
  let l:title = w:quickfix_title
  call setqflist(uniq(getqflist()), 'r')
  call setqflist([], 'a', {"title": l:title})
  if s:ccl | cclose | endif
endfunction

function! cscope#init() abort
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

      if !empty(l:csdb)
        augroup CSCOPE_GTAGS_DUPLICATES
          autocmd!

          autocmd QuickFixCmdPre cscope
                \ let s:ccl = empty(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist'))

          autocmd QuickFixCmdPost cscope call <SID>handleDups()
        augroup END
      endif
    endif
  endif

  let &cscopeverbose = csverb_old
endfunction
