let g:ada_extended_completion = 1
let g:ada_folding             = "i"
let g:ada_omni_with_keywords  = 1

setlocal tabstop=3

compiler! gnat

let b:sBnR = #{ make: [ 0, "gnatmake % && gnatclean -c %" ] }
