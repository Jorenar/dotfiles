" misc. {{{1
"   include guards {{{2

hi! link cIncludeGuards MoreMsg

syntax region cIncludeGuarded transparent matchgroup=cIncludeGuards
      \ start = "\v#ifndef \z((.+_H.*_?))\n#define \1"
      \ end   = "\v#endif\ze /[/*] \z1>"


"   extern "C" {{{2

syntax region cExternC transparent matchgroup=MoreMsg
      \ start = '\v#ifdef __cplusplus\nextern "C" \{\n#endif'
      \ end   = '\v#ifdef __cplusplus\n}%(\s*//.*)?\n#endif'



" bad style warnings {{{1
"   'case' label {{{2

syn clear cLabel
syn match cLabel "\v<%(case|default)>\ze%(\s+\S+)?\s*:" display
syntax match cCaseBadFormat "\v%(<%(case|default)>.*)@<!%(\S.*)@<=<%(case|default)>\ze%(\s+\S+)?\s*:" display
hi def link cCaseBadFormat cError

"   fix false positive curly error {{{2

if exists("c_curly_error") && &ft == "c"
  silent! syn clear cBlock
  syn region cBlock_ start="{" end="}" transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,@cStringGroup,@Spell
endif

" folding with brace in newline {{{1

if &ft !~# '\v<(c|cpp)>' | finish | endif

if !get(g:, "c_fold_brace_nl_style", 1)
  if !get(b:, "c_fold_brace_nl_style", 1)
    finish
  endif
endif

let s:pattern = '%('

if &ft ==# "cpp"
  " struct/class inheriting
  let s:pattern .= ''
        \ . '%(<struct|<class)@<='
        \ . '\s\ze\s*\S+[^:]:[^:]\s*\S+.*'
  let s:pattern .= '|'

  " Constructors
  let s:pattern .= ''
        \ . '%('
        \ .    '%([^,:]|\n|^|<%(public|private|protected)>\s*:)'
        \ .    '\n\s*'
        \ . ')@<='
        \ . '%(<%(while|for|if|switch|catch)>)@!'
        \ . '\S\ze\S*%(::\S+)*\s*\(.*\)\s*%(:.*)?'
  let s:pattern .= '|'
endif

let s:pattern .= '%(<%(while|for|if|switch|catch)\(.*)@<=\)\ze\s*' . '|'

let s:pattern .= ''
      \ . '%('
      \ .    '^\s*%(//.*|.*\*/|\{|<%(public|private|protected)>\s*:|.*\>)?'
      \ .    '\s*\n\s*\S+'
      \ . ')@<='
      \ . '\s\ze\s*\S+\s*'
      \ . '%(.*[^:]:[^:].*)@!'
      \ . '%(\s+\S+)*'

let s:pattern .= ')%(;\s*)@<!%(//.*|/\*.*\*/)?\n\s*'


let s:contains = ''
if exists("c_curly_error")
  let s:contains = ' contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,@cStringGroup,@Spell'
endif

silent! syn clear cBlock cBlock_
exec 'syn region cBlock_ end="}" fold' . s:contains
      \ . ' start = "\%#=1\C\v' . s:pattern . '\{"'
      \ . ' start = "\%#=1\C\v%(' . s:pattern . ')@<!\{"'

unlet s:contains s:pattern
