" syntaxMarkerFold
" Maintainer:  Jorengarenar <https://joren.ga>
" License:     MIT

if exists("g:loaded_syntaxMarkerFold") | finish | endif
let s:cpo_save = &cpo | set cpo&vim

let s:attr = " matchgroup=Comment transparent fold containedin=ALL"

function! s:genLeveled(lvl) abort
  let l:higherLvls = ""
  for l:i in range(a:lvl-1, 0, -1)
    let l:higherLvls .= " end = ".s:d.'\ze' . s:op[1:] . l:i . s:ed
    let l:higherLvls .= " end = ".s:d.'\ze' . s:cl[1:] . l:i . s:ed
  endfor

  exec "syn region syntaxMarkerFold" . s:attr
        \ "start = " . s:op . a:lvl . s:ed
        \ "end   = " . s:cl . a:lvl . s:ed
        \ "end   = " . s:d . '\ze' . s:op[1:] . a:lvl . s:ed
        \ l:higherLvls
        \ "end   = " . s:d . '\ze' . s:cl[1:] . s:ed[:1] . '$' . s:d
endfunction

function! s:init() abort
  let l:comm = split(&l:comments, ',')
  call map(l:comm, 'substitute(v:val, ".\\{-}:", "", "")')
  let l:comm = '\%(' . join(l:comm, '\|') . '\)'

  let s:d = l:comm !~ "/" ? "/" : "'"   " pattern delimiter
  let [ l:m1, l:m2 ] = split(&l:foldmarker, ",")

  let s:st = s:d . '\V\s\*' . l:comm . '\.\{-}'
  let s:op = s:st . l:m1
  let s:cl = s:st . l:m2
  let s:ed = '\v(\s.*)?' . s:d

  silent! syn clear syntaxMarkerFold
  exec "syn region syntaxMarkerFold" . s:attr
        \ "start = " . s:op . s:ed
        \ "end   = " . s:cl . s:ed

  let l:maxlvl = get(b:, "syntaxMarkerFold_maxlevel", get(g:, "syntaxMarkerFold_maxlevel", 5))
  for l:lvl in range(1, l:maxlvl)
    call s:genLeveled(l:lvl)
  endfor
endfunction

augroup syntaxMarkerFold
  autocmd!
  autocmd Syntax * call s:init()
  autocmd OptionSet comments call s:init()
  autocmd OptionSet foldmarker call s:init()
augroup END

let g:loaded_syntaxMarkerFold = 1
let &cpo = s:cpo_save | unlet s:cpo_save
