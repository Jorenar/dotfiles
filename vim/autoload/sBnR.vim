function! sBnR#run(file, ...) abort

  let options = #{
        \   term_name: "sB&R [" .&ft. "]  ",
        \   term_finish: "open",
        \   norestore: 1,
        \   exit_cb: { _, nr -> execute('let &l:stl .= "  (".nr.")"') },
        \ }
  let detach = 0

  if exists("b:sBnR") && has_key(b:sBnR, "run")
    let cmd = b:sBnR.run[1]

    if b:sBnR.run[0] == 1
      let options.term_finish = "close"
    elseif b:sBnR.run[0] == 2
      let detach = 1
    endif

  elseif executable("./" . a:file)
    let cmd = "./" . a:file
  elseif exists("b:sBnR") && b:sBnR.make[0]
    let cmd = b:sBnR.make[1]
  else
    echo "I don't know how to execute this file!"
    return
  endif

  let cmd .= " ".get(a:, 1, "")
  let options.term_name .= cmd
  let cmd = expandcmd(cmd)

  if detach
    call system(cmd." &")
  elseif has('nvim')
    execute "tabe term://".cmd
    if options.term_finish == "close"
      autocmd TermClose <buffer> call feedkeys("q")
    else
      autocmd TermClose <buffer> call feedkeys("\<C-\>\<C-n>")
    endif
  else
    let buf = term_start(&shell, options)
    wincmd T
    call term_sendkeys(buf, "trap 'exit' SIGINT SIGTERM\<CR>")
    call term_sendkeys(buf, "trap '' SIGTSTP\<CR>")
    call term_sendkeys(buf, 'printf "\033[2J\033[H"; '.cmd."; exit 2> /dev/null\<CR>")
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

  if exists("b:sBnR") && has_key(b:sBnR, "make")
    let cmd = "(" . b:sBnR.make[1] . " " . get(a:, 1, "") . ")"

    if b:sBnR.make[0]
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
