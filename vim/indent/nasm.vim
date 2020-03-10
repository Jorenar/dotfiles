" Vim indent file
" Language: Assembly
" Author:   Jorengarenar <joren.ga>

for dir in split(globpath(&rtp, 'indent'), "\n")
  if filereadable(dir."/asm.vim")
    execute "source ".dir."/asm.vim"
    break
  endif
endfor
