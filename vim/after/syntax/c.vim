" vim: fdm=marker fen fdl=1

" FOLDING {{{1
" Marker {{{2

syntax region cMarkerFold matchgroup=cCommentL start='//.*{{{' end='//.*}}}' transparent fold

" Switch's cases {{{2

syntax region cCaseFold
      \ start = "\v(<%(case|default)>)@<=\ze(.*((//.*)|(/\*.*(\*/)@!))@<!(<%(case|default)>))@!"
      \ skip  = "\v\n*\s*((//.*)|(/\*\_.*\*/\s*))$"
      \ end   = "\v\n\ze\n*.*(<%(case|default)>)@<="
      \ end   = "\n\ze\n*.*}"
      \ transparent fold

" Multiline macro {{{2

syntax region cMacroFold start="#define .*\\$" end="\\\n\(.*\\$\)\@!.*" keepend transparent fold

" Long comment {{{2

syntax region cLongComment start="^\s*//.*\n\ze\(\s*//.*\n\)\{3,}" end="^\(//\)\@!" fold
hi link cLongComment cCommentL
