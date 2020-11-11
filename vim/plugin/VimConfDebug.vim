function VimConfDebug()

  " WhatHighlightsIt - check highlight group under the cursor
  function! WhatHighlightsIt() abort
    let [ l, c, n ] = [ line("."), col("."), "name" ]
    echo "hi<"
          \ . synIDattr(synID(l, c, 1), n)             . '> trans<'
          \ . synIDattr(synID(l, c, 0), n)             . "> lo<"
          \ . synIDattr(synIDtrans(synID(l, c, 1)), n) . ">"
  endfunction

  nnoremap zS :echo join(reverse(map(synstack(line('.'), col('.')), 'synIDattr(v:val,"name")')),' ')<CR>

endfunction
