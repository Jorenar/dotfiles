function! utils#syntax#rule_append(group, addition) abort
  let rules = execute("silent syntax list " . a:group)
  let rules = split(rules, '\n')
  let rules = filter(rules, 'v:val !~ "--- Syntax items ---"')
  let rules = filter(rules, 'v:val !~ " links to "')

  exec "silent syntax clear" a:group

  for rule in rules
    let type = rule =~# ' match ' ? 'match' :
          \      rule =~# ' start=/' ? 'region' :
          \        'keyword'
    let rule = substitute(rule, a:group.'\s\+xxx ', ' ', 'g')
    let rule = substitute(rule, '\_s\+', ' ', 'g')
    exec "silent syntax" type a:group rule a:addition
  endfor
endfunction
