setlocal tabstop=2
setlocal equalprg=xmllint\ --format\ -
SetFormatProg "tidy -xml -q -m -w -i --show-warnings 0 --show-errors 0"
