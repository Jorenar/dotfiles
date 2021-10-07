if !has("cscope") || !executable("cscope")
  finish
endif

let db = findfile("cscope.out", ".git;")
if !empty(db)
  let [ csverb_old, &cscopeverbose ] = [ &cscopeverbose, 0 ]
  exe "cs add ".db." ".strpart(db, 0, match(db, ".git/cscope.out$"))
  let &cscopeverbose = csverb_old
  unlet csverb_old
elseif filereadable("cscope.out")
  cs add cscope.out
elseif $CSCOPE_DB
  cs add $CSCOPE_DB
endif

set cscopetag
set cscopetagorder=0
set cscopepathcomp=2

nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>a :cs find a <C-R>=expand("<cword>")<CR><CR>

nnoremap <C-\><C-i> :cs find i ^%:t$<CR>
