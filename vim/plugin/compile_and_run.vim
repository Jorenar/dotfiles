if exists('g:loaded_') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

let s:compiler_for_filetype = {
            \ "c,cpp"    : "gcc",
            \ "go"       : "go",
            \ "haskell"  : "ghc",
            \ "html"     : "tidy",
            \ "perl"     : "perl",
            \ "php"      : "php",
            \ "plaintex" : "tex",
            \ "python"   : "pyunit",
            \ "tex"      : "tex",
            \}

let s:makeprg_for_filetype = {
            \ "asm"      : "as -o %<.o % && ld -s -o %< %<.o && rm %<.o && ./%<",
            \ "basic"    : "vintbas %",
            \ "c"        : "gcc -std=gnu11 -g % -o %< && ./%<",
            \ "cpp"      : "g++ -std=gnu++11 -g % -o %< && ./%<",
            \ "go"       : "go build && ./%<",
            \ "haskell"  : "ghc -o %< %; rm %<.hi %<.o && ./%<",
            \ "html"     : "tidy -quiet -errors --gnu-emacs yes %:S; firefox -new-window % &",
            \ "lisp"     : "clisp %",
            \ "lua"      : "lua %",
            \ "markdown" : "grip --quiet -b %",
            \ "nasm"     : "yasm -f elf64 % && ld -g -o %< %<.o && rm %<.o && ./%<",
            \ "perl"     : "perl %",
            \ "plaintex" : "pdftex -file-line-error -interaction=nonstopmode % && zathura %<.pdf",
            \ "python"   : "python %",
            \ "rust"     : "rustc % && ./%<",
            \ "sh"       : "chmod +x %:p && %:p",
            \ "tex"      : "pdflatex -file-line-error -interaction=nonstopmode % && zathura %<.pdf",
            \ "xhtml"    : "tidy -asxhtml -quiet -errors --gnu-emacs yes %:S; firefox -new-window % &",
            \}

let &shellpipe="2> >(tee %s)"

for [ft, comp] in items(s:compiler_for_filetype)
    execute "autocmd filetype ".ft." compiler! ".comp
endfor

function! CompileAndRun() abort
    write
    let l:makeprg_temp = &makeprg
    let &l:makeprg = "(".s:makeprg_for_filetype[&ft].")"
    make
    let &l:makeprg = l:makeprg_temp
endfunction

nnoremap <F9> :call CompileAndRun()<CR>

let g:loaded_ = 1
let &cpo = s:cpo_save | unlet s:cpo_save
