setlocal tabstop=2


function! YamlFolds()
  let prev_level = indent(prevnonblank(v:lnum - 1)) / shiftwidth()
  let cur_level  = indent(v:lnum) / shiftwidth()
  let next_level = indent(nextnonblank(v:lnum + 1)) / shiftwidth()

  if getline(v:lnum + 1) =~ '^\s*$'
    return "="
  elseif cur_level < next_level
    return next_level
  elseif cur_level > next_level
    return ('s' . (cur_level - next_level))
  elseif cur_level == prev_level
    return "="
  endif

  return next_level
endfunction

setlocal foldmethod=expr foldexpr=YamlFolds()
