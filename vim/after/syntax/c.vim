" vim: fdm=marker fen

" Marker fold {{{1
syntax region cMarkerFold matchgroup=cCommentL start='//.*{{{' end='//.*}}}' transparent fold

" Fold switch's cases {{{1

call KeywordGroupContained("cLabel")
syntax region cCaseFold  start="case" start="default" end="\n\ze\n*.*\(case\|default\)" end="\n\ze\n*.*}" transparent fold
