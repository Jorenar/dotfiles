" FoldsCached
" Author:  Jorenar

if exists('g:loaded_FoldsCached') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

if empty($XDG_CACHE_HOME)
  let $XDG_CACHE_HOME  = $HOME."/.cache"
endif

function! FoldsCached(mk) abort
  if !exists("b:FoldsCached_fdm") | return | endif
  if b:FoldsCached_fdm !~ '\v(syntax|expr)' | return | endif

  if !filereadable(expand("%:p")) | return | endif

  let dir = $XDG_CACHE_HOME . "/vim/folds/"
  let foldfile = dir . substitute(expand("%:p"), "/", "=+", "g") . "="

  if a:mk && !&mod
    call mkdir(dir, 'p', 0700)

    let [ vop_old, &viewoptions ] = [ &viewoptions, "folds" ]
    exec "mkview!" foldfile
    let &viewoptions = vop_old

    let folds = readfile(foldfile)
    call filter(folds, {_,l -> l =~ '\v^(sil! )?\d+,\d+fold$'})
    call uniq(folds)

    if !empty(folds)
      let preamble = [
            \   '" vim: set ft=vim :',
            \   'if line("$") != ' . line("$") . ' | finish | endif',
            \   'norm! zE'
            \ ]
      call writefile(preamble + folds, foldfile)
    else
      call delete(foldfile)
    endif
  elseif filereadable(foldfile)
    exec "source" foldfile
  endif
endfunction

augroup FOLDS_CACHED
  autocmd!
  autocmd BufReadPost * let b:FoldsCached_fdm = &fdm |
        \ if &fdm =~ '\v(syntax|expr)' | setl fdm=manual | endif

  autocmd BufReadPost ?* call FoldsCached(0)
  autocmd BufUnload   ?* call FoldsCached(1)
augroup END

function! UpdateFolds() abort
  if exists("b:FoldsCached_fdm") && b:FoldsCached_fdm != &fdm
    if &fdm != "manual"
      let b:FoldsCached_fdm = &fdm
    endif

    let l:syn_old = &syntax
    if b:FoldsCached_fdm == "syntax" && &syntax ==? "off"
      setl syntax=ON
    endif

    let &l:fdm = b:FoldsCached_fdm
    norm! zx
    setl fdm=manual

    if &syntax != l:syn_old
      let &syntax = l:syn_old
    endif
  else
    norm! zx
  endif
endfunction

nnoremap <silent> zx :call UpdateFolds()<CR>

let g:loaded_FoldsCached = 1
let &cpo = s:cpo_save | unlet s:cpo_save
