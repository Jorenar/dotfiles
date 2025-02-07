#!/usr/bin/env -S vim --clean -u

let s:cpo_save = &cpo | set cpo&vim

setlocal buftype=nofile
nnoremap <buffer> q :q<CR>

let num = 255
while num >= 0
  execute 'hi col_'.num.' ctermbg='.num.' ctermfg='.num
  execute 'syn match col_'.num.' "='.printf("%3d", num).'" containedIn=ALL'
  call append(0, ' '.printf("%3d", num).'  ='.printf("%3d", num))
  let num -= 1
endwhile

norm! gg

let &cpo = s:cpo_save | unlet s:cpo_save
