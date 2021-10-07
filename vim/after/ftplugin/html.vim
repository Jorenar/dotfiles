let g:html_indent_autotags = "html"
let g:html_indent_style1   = "inc"

setlocal foldmethod=syntax
setlocal tabstop=2
setlocal comments+=s1:/*,mb:*,ex:*/,://

let g:php_html_shitwidth = &l:sw ? &l:sw : &l:ts

compiler! tidy
SetFormatProg "tidy -q -w -i --show-warnings 0 --show-errors 0 --tidy-mark no"

let b:sBnR = #{
      \   make: [ 0, "tidy -quiet -errors --gnu-emacs yes %" ],
      \   run:  [ 1, "$BROWSER %:p" ],
      \ }
