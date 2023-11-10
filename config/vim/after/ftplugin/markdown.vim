setlocal tabstop=2
setlocal foldmethod=syntax

setlocal formatprg=

if &fdm != "syntax"
  let g:markdown_fenced_languages = [ 'c', 'cpp', 'html', 'javascript', 'python', 'sh', 'sql', 'vim' ]
  let g:markdown_folding = 1
endif

if has("nvim")
  nnoremap <buffer> <F8> :tabe term://grip --quiet -b %<CR>
else
  nnoremap <buffer> <F8> :tab term grip --quiet -b %<CR>
endif

let b:trimWhitespace_pattern = '\v(\S\zs\s|\s\s\zs\s+)$'
