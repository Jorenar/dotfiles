#!/usr/bin/env -S vim --clean -u

set nocp
set spell

if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME = $HOME.'/.local/share' | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME.'/.config'    | endif

set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after

function! Spelldump(langs) abort
  for l:lang in keys(a:langs)
    let &spelllang = l:lang
    spelldump
    silent! %substitute,/\d\+$,,
    exec 'wq!' a:langs[l:lang]
  endfor
endfunction


augroup SPELLDUMP
  au!
  autocmd VimEnter * call Spelldump({
        \   'en': 'english.txt',
        \   'pl': 'polish.txt',
        \ }) | quitall
augroup END
