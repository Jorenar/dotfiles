function! UltiSnips_complete(...) abort
  let l:word = matchstr(getline('.'), '\S\+\%'.col('.').'c')
  if !empty(UltiSnips#SnippetsInCurrentScope(1))
    let l:suggestions = map(filter(keys(g:current_ulti_dict_info), 'stridx(v:val, l:word) == 0'),
          \  '{
          \      "word": v:val,
          \      "menu": "  ".get(g:current_ulti_dict_info[v:val], "description", ""),
          \      "dup" : 1
          \   }')
    call complete(col('.') - len(l:word), l:suggestions)
  endif
  return ''
endfunction

inoremap <silent> <C-S-u> <C-r>=UltiSnips_complete()<CR>
