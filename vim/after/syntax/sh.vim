" vim: fdm=marker

" Embedding languages {{{1

function! s:embed(lang) abort
  if exists("b:current_syntax")
    let current_syntax_save = b:current_syntax
    unlet b:current_syntax
  endif

  exec 'syn include @'.a:lang.'Script syntax/'.a:lang.'.vim'
  exec 'syn region '.a:lang.'ScriptCode matchgroup=sedCommand start=+[=\\]\@<!'."'".'+ skip=+\\'."'+ end=+'+".' contains=@'.a:lang.'Script contained'
  exec 'syn region sedScriptEmbedded matchgroup=sedCommand start="\v(<'.a:lang.'>)@<=." skip=+\\$+ end=+[=\\]\@<!'."'".'+me=e-1 contains=@shIdList,@shExprList2 nextgroup='.a:lang.'ScriptCode'
  exec 'syn cluster shCommandSubList add='.a:lang.'ScriptEmbedded'
  exec 'hi def link '.a:lang.'Command Type'

  if exists("current_syntax_save")
    let b:current_syntax = current_syntax_save
  else
    unlet b:current_syntax
  endif
endfunction

call s:embed("awk")
call s:embed("sed")
