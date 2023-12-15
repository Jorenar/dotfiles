" Turn syntax highlighting off for everything except for comments
function! MinimalSyntax() abort
  let syn = split(execute('syn list'), "\n")[1:]
  call filter(syn, 'v:val =~ "^\\w"')
  call map(syn, 'split(v:val)[0]')
  call filter(syn, 'v:val !~? "\\v%(comment|string|error|warning)"')
  silent! exe 'syn clear' join(syn)
endfunction
