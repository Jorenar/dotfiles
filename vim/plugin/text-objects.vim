" Custom pseudo-text objects
"  inspired by gist pseudo-text-objects.vim by Romain Lafourcade


" 24 simple text objects
" -----------------------------
" i_ i. i: i, i; i| i/ i\ i* i+ i- i#
" a_ a. a: a, a; a| a/ a\ a* a+ a- a#
" can take a count: 2i: 3a/
for c in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
  execute "xnoremap i" . c . " :<C-u>execute 'normal! ' . v:count1 . 'T" . c . "v' . (v:count1 + (v:count1 - 1)) . 't" . c . "'<CR>"
  execute "onoremap i" . c . " :normal vi" . c . "<CR>"
  execute "xnoremap a" . c . " :<C-u>execute 'normal! ' . v:count1 . 'F" . c . "v' . (v:count1 + (v:count1 - 1)) . 'f" . c . "'<CR>"
  execute "onoremap a" . c . " :normal va" . c . "<CR>"
endfor | unlet c

" Line
" ------------------------
" il al
xnoremap il g_o^
onoremap il :<C-u>normal vil<CR>
xnoremap al $o0
onoremap al :<C-u>normal val<CR>

" Folds
" -----------------------------------
" iz az
xnoremap iz :<C-u>silent! norm! [zjV]zk<CR>
onoremap iz :<C-u>silent! norm Viz<CR>
xnoremap az :<C-u>silent! norm! [zV]z<CR>
onoremap az :<C-u>silent! norm Vaz<CR>
