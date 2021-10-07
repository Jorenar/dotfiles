setlocal colorcolumn=+31,+51
setlocal foldmethod=syntax

call mkdir($TMPDIR."/java", "p")

SetFormatProg "uncrustify --l JAVA base kr mb java"
compiler! "javac"

let b:sBnR = #{
      \   make: [ 0, "javac -d $TMPDIR/java %:p && jar cvfe %:t:r.jar %:t:r -C $TMPDIR/java ." ],
      \   run:  [ 0, "java -jar %:t:r.jar" ]
      \ }
