function! utils#motion#jump_DiffAdd(d) abort
  while search('^.*', 'wz'.(a:d < 0 ? 'b' : '')) > 0
    if synIDattr(diff_hlID(line('.'), col('.')), 'name') is# 'DiffAdd'
      break
    endif
  endwhile
endfunction

function! utils#motion#VSetSearch(cmdtype) abort " search for selected text, forwards or backwards
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction
