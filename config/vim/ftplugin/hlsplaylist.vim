setlocal foldmethod=syntax
autocmd Syntax <buffer> syn region m3uExtinfFold start="#EXTINF" end="^$\n" transparent fold
