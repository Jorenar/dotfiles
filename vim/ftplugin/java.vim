setlocal colorcolumn=+31,+51
setlocal foldmethod=syntax

call mkdir($TMPDIR."/java", "p")

SetFormatProg "uncrustify --l JAVA base kr mb java"

setlocal errorformat=%E%f:%l:\ error:\ %m,
      \%W%f:%l:\ warning:\ %m,
      \%-Z%p^,
      \%-C%.%#,
      \%-G%.%#
