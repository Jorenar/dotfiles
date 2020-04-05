" vim: fdm=marker

" Fold switch case {{{1

syntax clear cLabel cStatement

syntax keyword cStatement   asm continue goto return

syntax match cLabel "case"
syntax match cLabel "default"
syntax match cStatement "break"

syntax match cCaseFold "\(case [0-9'a-zA-Z]\+\|default\):\(\n\s*case\)\@!\_.\{-}break;" transparent fold
