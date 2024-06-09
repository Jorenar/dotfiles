let g:tex_fold_enabled = 1
setlocal foldmethod=syntax
setlocal tabstop=3
setlocal textwidth=90

let b:ale_linters_ignore = [ 'lacheck' ]

let g:tex_fold_envs = ""
      \ ." algorithm"
      \ ." align"
      \ ." enumerate"
      \ ." equation"
      \ ." figure"
      \ ." gather"
      \ ." itemize"
      \ ." lstlisting"
      \ ." minipage"
      \ ." multicols"
      \ ." table"
      \ ." tabular"
      \ ." tcolorbox"
      \ ." tikzpicture"
      \ ." verbatim"


nnoremap <buffer> <F8> <Cmd>sil! call system(
      \ 'zathura'
      \ ." ". '-x "nvr --remote +%{line} %{input}"'
      \ ." ". '--synctex-forward'
      \ ." ". line('.') . ':' . col('.') . ':' . expand('%:p')
      \ ." ". expand('%:p:r') . '.pdf'
      \ ." ". '&'
      \ )<CR>
