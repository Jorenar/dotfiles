" Vim indent file
" Author: Jorengarenar <joren.ga>

if exists("b:did_indent") | finish | endif | let b:did_indent = 1

function! GetSshIndent() abort
  let line = getline(v:lnum)

  " If the line is a "Host" then indent to first column
  if line =~ '^Host .*'
    return 0
  elseif line =~ '^\s*#.*' " Don't change indentation of comments
    return -1
  else
    return shiftwidth()
  endif
endfunction

setlocal indentexpr=GetSshIndent()
