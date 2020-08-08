" vim: fdm=marker fen

" Fold access {{{1

syntax clear cppAccess
syntax match cppAccess "public\|protected\|private"
syntax region cAccessFold  start="private" start="public" start="protected" end="\n\ze\n*.*\(public\|private\|protected\)" end="\n\ze\n*.*}" transparent fold
