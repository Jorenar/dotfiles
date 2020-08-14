" vim: fdm=marker fen fdl=1

" FOLDING {{{1
" Class access specifiers {{{2

syntax region cAccessFold transparent fold
      \ start = "\v(<%(public|private|protected)>)@<=\s*:"
      \ skip  = "\v\n*\s*((//.*)|(/\*\_.*\*/\s*)|(.*\".*\".*;))$"
      \ end   = "\v\n?\ze\n*.*<%(public|private|protected)>"
      \ end   = "\n\ze\n*.*}"

" Boost test suite {{{2

syntax region boostTestSuite start="\v<BOOST_\w+_TEST_SUITE>" end="BOOST_AUTO_TEST_SUITE_END" transparent fold
