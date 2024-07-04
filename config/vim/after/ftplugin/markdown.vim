setlocal tabstop=2
setlocal foldmethod=syntax

setlocal formatprg=

if &fdm != "syntax"
  let g:markdown_fenced_languages = [ 'c', 'cpp', 'html', 'javascript', 'python', 'sh', 'sql', 'vim' ]
  let g:markdown_folding = 1
endif

let b:trimWhitespace_pattern = '\v(\S\zs\s|\s\s\zs\s+)$'

if has("nvim")
  nnoremap <buffer> <F8> :hor term://grip -b %<CR>
else
  nnoremap <buffer> <F8> :hor term grip -b %<CR>
endi
