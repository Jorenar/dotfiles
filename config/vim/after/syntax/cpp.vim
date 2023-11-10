syn clear cErrInBracket
syn match cErrInBracket display contained "[);}]\|<%\|%>"

syntax match cppIppIncludeGuards
      \ "\v#ifndef .+_H.*_?\n#\s*error.*included.*header.*\n#endif"
hi! link cppIppIncludeGuards cIncludeGuards

" IPP_TPL macro
syn match cppIppTpl /\v#(define|undef) IPP_TPL.*/
syn keyword cppIppTpl IPP_TPL conceal cchar=τ
hi! link cppIppTpl MoreMsg

syntax match cppMultilineConstructor transparent fold
      \ '\v^\s*\S+\s*\(.*\)\s*:%(\_s*\S.*,)*\n%(\s*\S.*,)*\_s*\S.*\_s*%(\{\s*\}|\ze^\s*\{)'

syntax region boostTestSuite transparent fold
      \ start="\v<BOOST_\w+_TEST_SUITE>" end="BOOST_AUTO_TEST_SUITE_END"
