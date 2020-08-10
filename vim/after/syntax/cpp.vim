" vim: fdm=marker fen fdl=1

" FOLDING {{{1
" Class access specifiers {{{2

syntax region cAccessFold
      \ start = "\v(<%(public|private|protected)>)@<=\ze(.*((//.*)|(/\*.*(\*/)@!))@<!(<%(public|private|protected)>))@!"
      \ skip  = "\v\n*\s*((//.*)|(/\*\_.*\*/\s*))$"
      \ end   = "\v\n\ze\n*.*<%(public|private|protected)>"
      \ end   = "\n\ze\n*.*}"
      \ transparent fold

" Boost test suite {{{2

syntax region boostTestSuite start="\v<BOOST_\w+_TEST_SUITE>" end="BOOST_AUTO_TEST_SUITE_END" transparent fold
