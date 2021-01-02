setlocal foldmethod=syntax
setlocal colorcolumn=+31,+51

if exists('g:JavaComplete_PluginLoaded')
  setlocal omnifunc=javacomplete#Complete
  let g:JavaComplete_EnableDefaultMappings = 0
  let g:JavaComplete_BaseDir = "$XDG_CACHE_HOME"
endif

call mkdir($TMPDIR."/java", "p")
