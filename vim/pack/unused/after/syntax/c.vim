" Include guards ----------------------------------

hi! link cIncludeGuards MoreMsg

syntax region cIncludeGuarded transparent matchgroup=cIncludeGuards
      \ start = "\v#ifndef \z((.+_H.*_?))\n#define \1"
      \ end   = "\v#endif\ze /[/*] \z1>"


" Extern "C" --------------------------------------

syntax region cExternC transparent matchgroup=MoreMsg
      \ start = '\v#ifdef __cplusplus\nextern "C" \{\n#endif'
      \ end   = '\v#ifdef __cplusplus\n}%(\s*//.*)?\n#endif'



" BAD STYLE --------------------------------------------------------------------

" 'case' label ------------------------------------

syn clear cLabel
syn match cLabel "\v<%(case|default)>\ze%(\s+\S+)?\s*:" display
syntax match cCaseBadFormat "\v%(<%(case|default)>.*)@<!%(\S.*)@<=<%(case|default)>\ze%(\s+\S+)?\s*:" display
hi def link cCaseBadFormat cError

" Fix false positive curly error ------------------

if exists("c_curly_error") && &ft == "c"
  silent! syn clear cBlock
  syn region cBlock_ start="{" end="}" transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,@cStringGroup,@Spell
endif
