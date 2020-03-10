" Vim indent file
" Language: fish
" Author:   Robert Audi

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

let s:cpo_save = &cpo | set cpo&vim

" Set the indent settings
setlocal indentexpr=GetFishIndent()
setlocal indentkeys+=e,=case,=end

" Only define the function once.
if exists("*GetFishIndent")
  finish
endif

" Keywords to indent after
let g:INDENT_AFTER = '\v^<%(if|else|for|while|function|switch|case|begin)>'
let g:CONTINUATION = '\v\\$'
let g:OUTDENT_DURING = '\v^<%(else|case|end)>'
let g:MULTILINE_STATEMENT = '\v;'

" Syntax names for comments
let g:SYNTAX_COMMENT = '\vfishComment'
let g:SYNTAX_STRING = '\vfishQuote'

" Get the true shift width.
if exists('*shiftwidth')
  let g:Shiftwidth = function('shiftwidth')
else
  function g:Shiftwidth()
    return &sw
  endfunction
endif

" Get the linked syntax name of a character.
function! g:SyntaxName(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name')
endfunction

" Check if a character is in a comment.
function! g:IsComment(lnum, col)
  return g:SyntaxName(a:lnum, a:col) =~ g:SYNTAX_COMMENT
endfunction

" Check if a character is in a string.
function! g:IsString(lnum, col)
  return g:SyntaxName(a:lnum, a:col) =~ g:SYNTAX_STRING
endfunction

" Check if a character is in a comment or string.
function! g:IsCommentOrString(lnum, col)
  let l:either = g:SYNTAX_COMMENT.'|'.g:SYNTAX_STRING
  return g:SyntaxName(a:lnum, a:col) =~ l:either
endfunction

" Check if a line is a multi-statement line.
function! g:IsMultiStatement(lnum)
  return g:SmartSearch(a:lnum, g:MULTILINE_STATEMENT)
endfunction

" Check if a whole line is a comment.
function! g:IsCommentLine(lnum)
  " Check the first non-whitespace character.
  return g:IsComment(a:lnum, indent(a:lnum) + 1)
endfunction


" Search a line for a regex until one is found outside a string or comment.
function! g:SmartSearch(lnum, regex)
  " Start at the first column.
  let col = 0

  " Search until there are no more matches, unless a good match is found.
  while 1
    call cursor(a:lnum, col + 1)
    let [_, col] = searchpos(a:regex, 'cn', a:lnum)

    " No more matches.
    if !col
      break
    endif

    if !g:IsCommentOrString(a:lnum, col)
      return 1
    endif
  endwhile

  " No good match found.
  return 0
endfunction


" Get the nearest previous line that isn't a comment.
function! g:GetPrevNormalLine(startlnum)
  let curlnum = a:startlnum

  while curlnum
    let curlnum = prevnonblank(curlnum - 1)

    if !g:IsCommentLine(curlnum)
      return curlnum
    endif
  endwhile

  return 0
endfunction


" Try to find a comment in a line.
function! g:FindComment(lnum)
  call cursor(a:lnum, 0)

  " Current column
  let cur = 0
  " Last column in the line
  let end = col('$') - 1

  while cur != end
    call cursor(0, cur + 1)
    let [_, cur] = searchpos('#', 'cn', a:lnum)

    if !cur
      break
    endif

    if g:IsComment(a:lnum, cur)
      return cur
    endif
  endwhile

  return 0
endfunction


" Get a line without comments or surrounding whitespace.
function! g:GetTrimmedLine(lnum)
  let comment = g:FindComment(a:lnum)
  let line = getline(a:lnum)

  if comment
    " Subtract 1 to get to the column before the comment and another 1 for
    " zero-based indexing.
    let line = line[:comment - 2]
  endif

  return substitute(substitute(line, '^\s\+', '', ''),
        \                                  '\s\+$', '', '')
endfunction


function! GetFishIndent()
  if v:lnum == 1
    return -1
  endif

  let pnum = v:lnum - 1

  if g:IsCommentLine(pnum)
    return indent(pnum)
  endif

  let pnum = g:GetPrevNormalLine(v:lnum)
  if !pnum
    return -1
  endif
  let ind = indent(pnum)

  if g:IsMultiStatement(pnum)
    return ind
  endif

  " Indent based on the current line.
  let prevline = g:GetTrimmedLine(pnum)
  " TODO: This doesn't handle multi-line strings
  " and is real stupid about ending continuations.
  if prevline =~ g:CONTINUATION
    return ind + (g:Shiftwidth() * 2)
  endif

  if prevline =~ g:INDENT_AFTER
    let ind += g:Shiftwidth()
  endif

  let curline = g:GetTrimmedLine(v:lnum)
  if curline =~ g:OUTDENT_DURING
    let ind -= g:Shiftwidth()
  endif

  return ind
endfunction

let &cpo = s:cpo_save | unlet s:cpo_save
