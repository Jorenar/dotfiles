let g:html_indent_autotags = "html"
let g:html_indent_style1   = "inc"

setlocal foldmethod=syntax
setlocal tabstop=2
setlocal comments+=s1:/*,mb:*,ex:*/,://

let g:php_html_shitwidth = &l:sw ? &l:sw : &l:ts

compiler tidy
nnoremap <buffer> <F8> <Cmd>call system($BROWSER.' '.shellescape(expand("%:p")).' &')<CR>

let b:ale_html_tidy_options = '-q -e'
      \ . ' --drop-empty-elements no'
      \ . ' --custom-tags inline --custom-tags blocklevel'
      \ . ' --mute PROPRIETARY_ELEMENT'
