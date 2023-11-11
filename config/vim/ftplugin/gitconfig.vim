setlocal foldmethod=syntax

autocmd Syntax <buffer>
      \ syn region gitSection fold
      \         start = '\s*\[.*\]'
      \         end = '\n\ze\n\S'
      \         end = '\ze\s*\[.*\]'
