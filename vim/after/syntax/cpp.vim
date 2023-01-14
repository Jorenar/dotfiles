" vim: fen fdl=1

syn clear cErrInBracket
syn match cErrInBracket display contained "[);}]\|<%\|%>"

" FOLDING {{{1
" .ipp include guard {{{2

syntax match cppIppIncludeGuards "\v#ifndef .+_H.*_?\n#\s*error.*included.*header.*\n#endif"
hi! link cppIppIncludeGuards cIncludeGuards

" IPP_TPL macro {{{2
syn match cppIppTpl /\v#(define|undef) IPP_TPL.*/
syn keyword cppIppTpl IPP_TPL conceal cchar=τ
hi! link cppIppTpl MoreMsg

" Multi line constructor {{{2

syntax match cppMultilineConstructor transparent fold '\v^\s*\S+\s*\(.*\)\s*:%(\_s*\S.*,)*\n%(\s*\S.*,)*\_s*\S.*\_s*%(\{\s*\}|\ze^\s*\{)'

" Boost test suite {{{2

syntax region boostTestSuite start="\v<BOOST_\w+_TEST_SUITE>" end="BOOST_AUTO_TEST_SUITE_END" transparent fold
