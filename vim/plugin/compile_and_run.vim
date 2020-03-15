let s:compiler_for_filetype = {
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

let s:makeprg_for_filetype = {
      \ "asm"      : "as -o %<.o % && ld -s -o %< %<.o && rm %<.o && ./%<",
      \ "basic"    : "vintbas %",
      \ "c"        : "gcc -std=gnu99 -g % -o %< && ./%<",
      \ "cpp"      : "g++ -std=gnu++14 -g % -o %< && ./%<",
      \ "go"       : "go build && ./%<",
      \ "haskell"  : "ghc -o %< %; rm %<.hi %<.o && ./%<",
      \ "html"     : "tidy -quiet -errors --gnu-emacs yes %:S; $BROWSER % &",
      \ "java"     : "mkdir -p build && javac -d build/ % && cd build && java %<",
      \ "lisp"     : "clisp %",
      \ "lua"      : "lua %",
      \ "markdown" : "grip --quiet -b %",
      \ "nasm"     : "nasm -f elf64 -g % && ld -g -o %< %<.o && rm %<.o && ./%<",
      \ "perl"     : "perl %",
      \ "plaintex" : "pdftex -interaction=nonstopmode % 1>&2 && zathura %<.pdf &",
      \ "python"   : "python %",
      \ "rust"     : "rustc % && ./%<",
      \ "sh"       : "chmod +x %:p && %:p",
      \ "tex"      : "pdflatex -interaction=nonstopmode % 1>&2 && zathura %<.pdf &",
      \ "xhtml"    : "tidy -asxhtml -quiet -errors --gnu-emacs yes %:S; $BROWSER % &",
      \}


for [ft, comp] in items(s:compiler_for_filetype)
  execute "autocmd filetype ".ft." compiler! ".comp
endfor

function! CompileAndRun() abort
  write

  let l:shellpipe_old = &shellpipe
  let &l:shellpipe    = "2>"

  let l:makeprg_temp  = &makeprg
  let &l:makeprg      = "(".s:makeprg_for_filetype[&ft].")"

  make

  let &l:makeprg      = l:makeprg_temp
  let &l:shellpipe    = l:shellpipe_old
endfunction

nnoremap <F9> :call CompileAndRun()<CR>
nnoremap <F10> :w <bar> make<CR>
