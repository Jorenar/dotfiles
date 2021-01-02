function! sBnR#run(file, ...) abort
  let options = ""
  let detach = 0

  if has_key(g:sBnR_runCmds, &ft)
    let cmd = g:sBnR_runCmds[&ft][1]

    if g:sBnR_runCmds[&ft][0] == 1
      let options = "++close "
    elseif g:sBnR_runCmds[&ft][0] == 2
      let detach = 1
    endif

  elseif executable("./" . a:file)
    let cmd = "./" . a:file
  elseif has_key(g:sBnR_makeprgs, &ft) && g:sBnR_makeprgs[&ft][0]
    let cmd = g:sBnR_makeprgs[&ft][1]
  else
    echo "I don't know how to execute this file!"
    return
  endif

  let cmd .= " ".get(a:, 1, "")

  if detach
    call system(expandcmd(cmd)." &")
  elseif has('nvim')
    execute "tabe term://".cmd
    if options == "++close "
      autocmd TermClose <buffer> call feedkeys("q")
    else
      autocmd TermClose <buffer> call feedkeys("\<C-\>\<C-n>")
    endif
  else
    execute "tab term ++shell ".options.cmd
  endif

endfunction

function! s:runInterpreter(cmd) abort
  let errorsfile = tempname()

  let cmd = a:cmd
  let cmd .= " 2>&1 "
  let cmd .= has('nvim') ? "\\|" : "\|"
  let cmd .= " tee ".errorsfile

  if has('nvim')
    execute "tabe term://".cmd
    augroup OPEN_ERROR_FILE
      autocmd!
      autocmd TermOpen  <buffer> let b:term_job_finished = 0
      autocmd TermEnter <buffer> if  b:term_job_finished | call feedkeys("\<C-\>\<C-n>") | endif
      execute "autocmd TermLeave <buffer> if !b:term_job_finished | cfile ".errorsfile." | endif"

      execute 'autocmd TermClose <buffer> let b:term_job_finished = 1 | call feedkeys("\<C-\>\<C-n>") | cfile '. errorsfile .' | copen'
    augroup END

  else

    function! s:OpenErrorFile_(ef, ...) abort
      execute "cfile ".a:ef
      cwindow
    endfunction

    let OpenErrorFile = function('s:OpenErrorFile_', [ errorsfile ])

    let cmd = expandcmd(cmd)
    tabe
    call term_start([ &shell, '-c', cmd ] , { "curwin": 1, 'exit_cb' : OpenErrorFile })
  endif

  setlocal switchbuf=usetab
endfunction

function! sBnR#build(...) abort
  write

  let interpreter = 0

  if has_key(g:sBnR_makeprgs, &ft)
    let cmd = "(" . g:sBnR_makeprgs[&ft][1] . " " . get(a:, 1, "") . ")"

    if g:sBnR_makeprgs[&ft][0]
      call s:runInterpreter(cmd)
      return v:false
    else
      let l:shellpipe_old = &shellpipe
      let &l:shellpipe    = "1>&2 2>"

      let l:makeprg_old = &makeprg
      let &l:makeprg    = cmd

      silent! make | redraw!

      let &l:makeprg   = l:makeprg_old
      let &l:shellpipe = l:shellpipe_old
    endif
  else
    execute "make %:t:r"
  endif

  return !v:shell_error
endfunction

function! sBnR#buildAndRun() abort
  let file = expand('%:t:r') " current file - in case of Vim jumping to other
  if sBnR#build()
    call sBnR#run(file)
  endif
endfunction


function! sBnR#addMakeprg(bang, ft, ...) abort
  let g:sBnR_makeprgs[a:ft] = [ a:bang, join(a:000) ]
endfunction

function! sBnR#addRunCmd(bang, ft, ...) abort
  let foo = 0
  let cmd = deepcopy(a:000)
  if a:bang
    let mode = cmd[0]
    call remove(cmd, 0)
    if mode == "detach"
      let foo = 1
    elseif mode == "close"
      let foo = 2
    endif
  endif
  let g:sBnR_runCmds[a:ft] = [ foo, join(cmd) ]
  echo g:sBnR_runCmds[a:ft]
endfunction

function! sBnR#addCompiler(ft, comp) abort
  let g:sBnR_makeprgs[a:ft] = a:comp
  execute "autocmd filetype ".a:ft." compiler! ".a:comp
endfunction
