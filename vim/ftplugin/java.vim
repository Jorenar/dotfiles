setlocal foldmethod=syntax
setlocal omnifunc=javacomplete#Complete

setlocal colorcolumn=+31,+51

let g:JavaComplete_EnableDefaultMappings = 0
let g:JavaComplete_BaseDir = "$XDG_CACHE_HOME"

call mkdir($TMPDIR."/java", "p")
