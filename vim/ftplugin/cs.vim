SetFormatProg "uncrustify --l CS base allman mb"

setlocal foldmethod=syntax

let b:sBnR = #{
      \   make: [ 0, "mcs %" ],
      \   run:  [ 0, "%:p:r.exe" ]
      \ }
