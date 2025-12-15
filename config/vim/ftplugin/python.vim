SetFormatProg "autopep8 --ignore=E501 -"
compiler pyunit

let g:python_recommended_style = 0

let g:python_indent = #{
      \   closed_paren_align_last_line: v:false,
      \   open_paren: 'shiftwidth()',
      \ }

setlocal foldmethod=syntax

let b:ale_python_pylint_options = '--disable=C,R,W1202'
