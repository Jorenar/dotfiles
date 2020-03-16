let s:compilers = {
      \ "c,cpp"    : "gcc",
      \ "go"       : "go",
      \ "haskell"  : "ghc",
      \ "html"     : "tidy",
      \ "java"     : "javac",
      \ "perl"     : "perl",
      \ "php"      : "php",
      \ "plaintex" : "tex",
      \ "python"   : "pyunit",
      \ "tex"      : "tex",
      \}

let s:makeprgs = {
      \ "asm"      : [ 0, "as -o %<.o % && ld -s -o %< %<.o && rm %<.o" ],
      \ "basic"    : [ 1, "vintbas %" ],
      \ "c"        : [ 0, "gcc -std=gnu99 -g % -o %<" ],
      \ "cpp"      : [ 0, "g++ -std=gnu++14 -g % -o %<" ],
      \ "go"       : [ 0, "go build" ],
      \ "haskell"  : [ 0, "ghc -o %< %; rm %<.hi %<.o" ],
      \ "html"     : [ 0, "tidy -quiet -errors --gnu-emacs yes %" ],
      \ "java"     : [ 0, "mkdir -p build && javac -d build/ %" ],
      \ "lisp"     : [ 1, "clisp %" ],
      \ "lua"      : [ 1, "lua %" ],
      \ "markdown" : [ 0, "grip --quiet -b %" ],
      \ "nasm"     : [ 0, "nasm -f elf64 -g % && ld -g -o %< %<.o && rm %<.o" ],
      \ "perl"     : [ 1, "perl %" ],
      \ "plaintex" : [ 0, "pdftex -interaction=nonstopmode % 1>&2" ],
      \ "python"   : [ 1, "python %" ],
      \ "rust"     : [ 1, "rustc %" ],
      \ "sh"       : [ 1, "chmod +x %:p && %:p" ],
      \ "tex"      : [ 0, "pdflatex -interaction=nonstopmode % 1>&2" ],
      \ "xhtml"    : [ 0, "tidy -asxhtml -quiet -errors --gnu-emacs yes %" ],
      \}

let s:run_cmds = {
      \ "html"     : [ 1, "$BROWSER %:p" ],
      \ "java"     : [ 0, "java -cp %:p:h/build %<" ],
      \ "plaintex" : [ 2, "zathura %:p:r.pdf" ],
      \ "tex"      : [ 2, "zathura %:p:r.pdf" ],
      \ "xhtml"    : [ 1, "$BROWSER %:p" ],
      \}


for [ft, comp] in items(s:compilers)
  execute "autocmd filetype ".ft." compiler! ".comp
endfor

function! Run() abort
  let options = ""
  if has_key(s:run_cmds, &ft)
    let cmd = s:run_cmds[&ft][1]
    if s:run_cmds[&ft][0]
      let options = "++close "
    endif
    if s:run_cmds[&ft][0] == 2
      let options = "++hidden ".cmd
    endif
  elseif executable(expand('%:p:r'))
    let cmd = "%:p:r"
  elseif has_key(s:makeprgs, &ft)
    let cmd = s:makeprgs[&ft][1]
  else
    echo "I don't know how to execute this file!"
  endif

  if has('nvim')
    execute "tabe term://".cmd
  else
    execute "tab term ++shell ".options.cmd
  endif

endfunction

function! Compile() abort
  write

  let interpreter = 0
  if has_key(s:makeprgs, &ft)
    let l:shellpipe_old = &shellpipe
    let &l:shellpipe    = "1>&2 2>"

    let l:makeprg_old = &makeprg
    let &l:makeprg    = "(".s:makeprgs[&ft][1].")"

    let interpreter = s:makeprgs[&ft][0]

    if interpreter
      make
    else
      silent! make | redraw!
    endif

    let &l:makeprg   = l:makeprg_old
    let &l:shellpipe = l:shellpipe_old
  else
    execute "make %<"
  endif

  return !(v:shell_error || interpreter)
endfunction

function! CompileAndRun() abort
  if Compile()
    call Run()
  endif
endfunction

nnoremap <F8>  :call Run()<CR>
nnoremap <F9>  :call CompileAndRun()<CR>
nnoremap <F10> :w <bar> make<CR>
