" vim: fdm=marker fen

" Marker fold {{{1
syntax region cMarkerFold matchgroup=cCommentL start='//.*{{{' end='//.*}}}' transparent fold

" Fold switch's cases {{{1

syntax clear cLabel
syntax match cLabel "case\|default"
syntax region cCaseFold  start="\(case\|default\)\ze\(.*case\)\@!" end="\n\ze\n*.*\(case\|default\|}\)" transparent fold
