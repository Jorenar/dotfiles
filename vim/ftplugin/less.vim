setlocal foldmethod=syntax
setlocal tabstop=2

SetFormatProg "css-beautify -s 2 --space-around-combinator"

augroup ft_LESS
  au!
  autocmd Syntax <buffer> silent! call utils#appendToSynRule("lessDefinition", "region", "fold")
augroup END
