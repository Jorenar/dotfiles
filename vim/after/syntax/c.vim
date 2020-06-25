" vim: fdm=marker fen

" Marker fold {{{1
syntax region cMarkerFold matchgroup=cCommentL start='//.*{{{' end='//.*}}}' transparent fold
