" vim: fdm=marker fen

" Fold access {{{1

call KeywordGroupContained("cppAccess")
syntax region cAccessFold  start="private" start="public" start="protected" end="\n\ze\n*.*\(public\|private\|protected\)" end="\n\ze\n*.*}" transparent fold
