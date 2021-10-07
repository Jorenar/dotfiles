let b:cobol_autoupper = 1
let b:cobol_folding   = 1

compiler cobc

imap <buffer> <unique> <C-j> <Plug>(miniSnip)
smap <buffer> <unique> <C-j> <Plug>(miniSnip)

let b:sBnR = #{ make: [ 0, "cobc -d -O -x -o %:t:r %" ] }
