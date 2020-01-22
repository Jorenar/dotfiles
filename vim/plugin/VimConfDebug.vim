function VimConfDebug()

  " WhatHighlightsIt - check highlight group under the cursor {{{2
  function! WhatHighlightsIt() abort
    echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
          \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
          \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
  endfunction

  nnoremap zS :echo join(reverse(map(synstack(line('.'), col('.')), 'synIDattr(v:val,"name")')),' ')<CR>

endfunction
