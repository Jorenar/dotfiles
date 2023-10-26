let g:tex_fold_enabled = 1
setlocal foldmethod=syntax
setlocal tabstop=3
setlocal textwidth=90

nnoremap <buffer> <F8> :sil! call system("zathura ".expand('%:t:r').".pdf &")<CR>

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
