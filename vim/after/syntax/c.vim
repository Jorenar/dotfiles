" vim: fdm=marker fen

" Poorly placed "case" label {{{1

syn clear cLabel
syn match cLabel "\v<%(case|default)>\ze(\s+\S+)?\s*:" display
syntax match cCaseBadFormat "\v(<%(case|default)>.*)@<!(\S.*)@<=<%(case|default)>\ze(\s+\S+)?\s*:" display
hi def link cCaseBadFormat cError

" FOLDING {{{1
" K&R style functions {{{2

" syntax clear cBlock
" syntax region cBlockImp end="}" transparent fold
"       \ start =  "\v\(.*\)\n\s*\{"
"       \ start = "\v(\(.*\)\n\s*)@<!\{"

" Marker {{{2

syntax region cMarkerFold matchgroup=cCommentL start='//.*{{{' end='//.*}}}' transparent fold

" Switch's cases {{{2

syntax region cCaseFold transparent fold
      \ start = "\v(<case>\s+\S+\s*)@<=:"
      \ start = "\v(<default>\s*)@<=:"
      \ skip  = "\v\n*\_.{-}\*/\n(\s*<%(case|default)>)@!"
      \ end   = "\v\n?\ze\n*\s*<%(case|default)>(\s+\S+)?\s*:"
      \ end   = "\v\n?\ze\n*(\s*//.*\n\s*)+<%(case|default)>(\s+\S+)?\s*:"
      \ end   = "\v\n?\ze\n+\s*/\*\_.{-}\*/\n?\s*<%(case|default)>(\s+\S+)?\s*:"
      \ end   = "\n\ze\n*.*}"

" Multiline macro {{{2

syntax region cMacroFold start="#define .*\\$" end="\\\n\(.*\\$\)\@!.*" keepend transparent fold

" Long comment {{{2

syntax region cLongComment start="^\s*//.*\n\ze\(\s*//.*\n\)\{3,}" end="^\(//\)\@!" fold
hi link cLongComment cCommentL
