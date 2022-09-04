setlocal tabstop=2
setlocal foldmethod=syntax

if &fdm != "syntax"
  let g:markdown_fenced_languages = [ 'c', 'cpp', 'html', 'javascript', 'python', 'sh', 'sql', 'vim' ]
  let g:markdown_folding = 1
endif

if has("nvim")
  nnoremap <buffer> <F8> :tabe term://grip --quiet -b %<CR>
else
  nnoremap <buffer> <F8> :tab term grip --quiet -b %<CR>
endif

augroup TRIM_TRAILING_WHITESPACE
  autocmd!
  autocmd BufWritePre * sil! undoj | sil! keepp keepj %s/\v(\S@<=\s$|(\s\s)@<=\s+|\_s+%$)//e
augroup END
