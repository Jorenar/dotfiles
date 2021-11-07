setlocal tabstop=2
setlocal foldmethod=syntax

if &fdm != "syntax"
  let g:markdown_fenced_languages = [ 'c', 'cpp', 'html', 'javascript', 'python', 'sh', 'sql', 'vim' ]
  let g:markdown_folding = 1
endif

nnoremap <F8> :call utils#term("grip --quiet -b %")<CR>
