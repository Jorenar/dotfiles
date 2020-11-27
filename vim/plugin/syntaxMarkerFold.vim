" syntaxMarkerFold
" Maintainer:  Jorengarenar <https://joren.ga>
" License:     MIT

if exists('g:loaded_syntaxMarkerFold') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

function! s:genLeveled(lvl) abort
  let l:higherLvls = ""
  for i in range(a:lvl-1, 0, -1)
    let l:higherLvls .= " end = '\\ze\\V" . s:st1[1:] . i . s:ed
    let l:higherLvls .= " end = '\\ze\\V" . s:st2[1:] . i . s:ed
  endfor

  exec "syn region syntaxMarkerFold" . a:lvl . " matchgroup=Comment transparent fold"
        \ "start = " . s:st1 . a:lvl . s:ed
        \ "end   = " . s:st2 . a:lvl . s:ed
        \ l:higherLvls
        \ "end   = '\\ze\\V" . s:st2[3:] . s:ed
        \ "end   = '\\ze\\V" . s:st1[3:] . s:ed

endfunction

function! s:init(...) abort
  let [ m1, m2 ] = split(&l:foldmarker, ",")

  let maxlvl = get(b:, "syntaxMarkerFold_maxlevel", get(g:, "syntaxMarkerFold_maxlevel", 5))

  if a:0 == 0
    let comm = split(&l:comments, ',')
    call map(comm, 'substitute(v:val, ".\\{-}:", "", "")')
    let comm = '\%(' . join(comm, '\|') . '\)'
  else
    let comm = a:1
  endif

  let s:st = "'\\V" . comm . "\\.\\{-}"
  let s:st1 = s:st . m1
  let s:st2 = s:st . m2
  let s:ed = "\\v(\\s.*)?'"

  exec "syn region syntaxMarkerFold matchgroup=Comment transparent fold"
        \ "start = " . s:st1 . s:ed
        \ "end   = " . s:st2 . s:ed

  for lvl in range(1, maxlvl)
    call s:genLeveled(lvl)
  endfor

endfunction

autocmd Syntax * call s:init()

let g:loaded_syntaxMarkerFold = 1
let &cpo = s:cpo_save | unlet s:cpo_save
