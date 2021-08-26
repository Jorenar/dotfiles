" Don't indent nested directories/lists
function! GetVimIndent1()
  let ind = GetVimIndentIntern()
  let prev = getline(prevnonblank(v:lnum - 1))
  if prev =~ '\s[{[]\s*$' && prev =~ '\s*\\'
    let ind -= shiftwidth()
  endif
  return ind
endfunction

setlocal indentexpr=GetVimIndent1()
