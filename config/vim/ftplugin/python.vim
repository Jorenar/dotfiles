SetFormatProg "autopep8 --ignore=E501 -"
compiler pyunit

let g:python_recommended_style = 0

setlocal foldmethod=syntax

let b:ale_python_pylint_options = '--disable=C,R,W1202'
