" vim: fdm=marker fen fdl=1

" Include guards {{{1

syntax region cIncludeGuarded transparent matchgroup=cIncludeGuard
      \ start="\v%1l#ifndef (.*)\n#define \1"
      \ end="#endif"

" BAD STYLE {{{1
" 'case' label {{{2

syn clear cLabel
syn match cLabel "\v<%(case|default)>\ze(\s+\S+)?\s*:" display
syntax match cCaseBadFormat "\v(<%(case|default)>.*)@<!(\S.*)@<=<%(case|default)>\ze(\s+\S+)?\s*:" display
hi def link cCaseBadFormat cError

" FOLDING {{{1
" Marker {{{2

syntax region cMarkerFold matchgroup=cCommentL start='//.*{{{' end='//.*}}}' transparent fold

" Switch's cases {{{2

syntax region cCaseFold transparent fold
      \ start = "\v(<case>\s+\S+\s*)@<=:(\s|$)"
      \ start = "\v(<default>\s*)@<=:"
      \ end   = "\v\n?\ze\n*\s*<%(case|default)>(\s+\S+)?\s*:"
      \ end   = "\v\n?\ze\n*(\s*//.*\n\s*)+<%(case|default)>(\s+\S+)?\s*:"
      \ end   = "\v\n?\ze\n+\s*/\*.*\*/\n?\s*<%(case|default)>(\s+\S+)?\s*:"
      \ end   = "\n\ze\n*.*}"

" Multiline macro {{{2

syntax region cMacroFold start="#define .*\\$" end="\v(\\\n)@<=.*[^\\]\_$" keepend transparent fold

" Long comment {{{2

syntax region cLongComment start="^\s*//.*\n\ze\(\s*//.*\n\)\{3,}" end="^\(//\)\@!" fold
hi link cLongComment cCommentL

" Preprocessor {{{2

syntax region cPreProcFold start="\v(%1l#ifndef)@!#if" end="#endif" transparent fold
