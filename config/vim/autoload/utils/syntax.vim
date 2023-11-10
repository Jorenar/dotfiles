function! utils#syntax#rule_append(group, addition) abort
  let rule = execute("silent syntax list " . a:group)
  let type = rule =~ "\<match\>" ? "match" : "region"
  exec "silent syntax clear" a:group
  let args = matchstr(rule, '\v.*<xxx\s+%(match>)?\zs.+\ze%(<links to .*|$)')
  let args = substitute(args, '\_s\+', ' ', 'g')
  exec "silent syntax" type a:group args a:addition
endfunction
