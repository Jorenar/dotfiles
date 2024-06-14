let g:html_indent_autotags = "html"
let g:html_indent_style1   = "inc"

setlocal foldmethod=syntax
setlocal tabstop=2
setlocal comments+=s1:/*,mb:*,ex:*/,://

let g:ale_html_tidy_options = "--drop-empty-elements 0"

let g:php_html_shitwidth = &l:sw ? &l:sw : &l:ts

compiler tidy
nnoremap <buffer> <F8> <Cmd>call system($BROWSER.' '.shellescape(expand("%:p")).' &')<CR>
SetFormatProg "tidy -q -w -i --show-warnings 0 --show-errors 0 --tidy-mark no"
