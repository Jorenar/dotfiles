setlocal tabstop=2
setlocal equalprg=xmllint\ --format\ -
set foldmethod=syntax
let g:xml_syntax_folding = 1
SetFormatProg "tidy -xml -q -m -w -i --show-warnings 0 --show-errors 0"
