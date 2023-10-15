setlocal foldmethod=syntax
autocmd Syntax <buffer> syn region task start='^@' end='\n\ze\n*\_^@' transparent fold
