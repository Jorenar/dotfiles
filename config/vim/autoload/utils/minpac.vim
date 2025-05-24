silent! packadd minpac
if !exists('g:loaded_minpac')
  finish
endif

function s:init(conf) abort
  let l:pluglist_bak = get(g:, 'minpac#pluglist', {})
  call minpac#init(a:conf)
  call extend(g:minpac#pluglist, l:pluglist_bak)
endfunction

function! utils#minpac#update() abort
  let l:iconf = get(g:, 'minpac_init_conf', {
        \   'jobs': -1
        \ })

  for l:group in values(get(g:, 'packs', {}))
    let l:gconf = get(l:group, 'conf', {})
    let l:pconf = get(l:gconf, 'pack', {})

    let l:list = get(l:group, 'list', {})
    if empty(l:list) | continue | endif

    call s:init(extend(deepcopy(l:iconf), get(l:gconf, 'init', {})))

    for l:name in keys(l:list)
      let l:url = get(l:list[l:name], 'url', '')
      if empty(l:url) | continue | endif
      let l:conf = get(l:list[l:name], 'conf', {})
      let l:conf.name = get(l:conf, 'name', l:name)
      call minpac#add(l:url, extend(deepcopy(l:pconf), l:conf))
    endfor
  endfor

  call s:init(l:iconf)

  call minpac#clean()
  call filter(g:minpac#pluglist, '!get(v:val, "_ignore", 0)')
  call minpac#update()
endfunction
