SetFormatProg "tidy -asxhtml -q -m -w -i --show-warnings 0 --show-errors 0 --tidy-mark no --doctype loose"

nnoremap <F8> :sil! call system("$BROWSER ".expand("%:p")." &")<CR>
