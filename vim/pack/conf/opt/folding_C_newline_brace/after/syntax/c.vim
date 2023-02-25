" File: after/syntax/c.vim

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
