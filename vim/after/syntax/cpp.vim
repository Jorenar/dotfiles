" vim: fdm=marker fen

" Fold access {{{1
syntax region cAccessFold  start="\v(<%(private|public|protected)>)@<=" end="\n\ze\n*.*\(public\|private\|protected\)" end="\n\ze\n*.*}" transparent fold
