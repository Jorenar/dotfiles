" Vim indent file
" Language:	Assembly
" Author:		Jorengarenar <joren.ga>

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nolisp
setlocal autoindent

setlocal indentexpr=GetAsmIndent()
setlocal indentkeys=<:>,!^F,o,O

if exists("*GetAsmIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

function! GetAsmIndent() abort
  let line = getline(v:lnum)

  " If the line is a label or section then indent to first column
  if line =~ '^\s*\k\+:' || line =~ '^section.*'
    return 0
  elseif line =~ '^\s*;.*' " Don't change indentation of comments
    return -1
  else
    return shiftwidth()
  endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
