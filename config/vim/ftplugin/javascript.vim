let javaScript_fold = 1

let b:foldtext_save = &foldtext
autocmd Syntax <buffer> let &foldtext = b:foldtext_save

setlocal foldmethod=syntax
setlocal tabstop=2

SetFormatProg "deno fmt --indent-width 2 -"
