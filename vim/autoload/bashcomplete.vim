function! bashcomplete#omnicomplete(findstart, base) abort
  if a:findstart
    let l:str = getline('.')[:col('.') - 2]
    let l:str = substitute(str, '[^ ]*$', '' , 'g')
    return len(s:str)
  endif

  return systemlist('bash -c "compgen -c ' . a:base . '"')
endfunction
