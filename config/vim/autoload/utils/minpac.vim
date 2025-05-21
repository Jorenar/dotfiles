silent! packadd minpac
if !exists('g:loaded_minpac')
  finish
endif

function s:init(conf) abort
  let l:pluglist_bak = get(g:, 'minpac#pluglist', {})
  call minpac#init(a:conf)
  call extend(g:minpac#pluglist, l:pluglist_bak)
endfunction

function s:add(sublist) abort
  if !has_key(g:packs, a:sublist) | return | endif
  for l:pack in values(g:packs[a:sublist])
    if !has_key(l:pack, 'url') | continue | endif
    call minpac#add(l:pack.url, get(l:pack, 'conf', {}))
  endfor
endfunction

function! utils#minpac#update() abort
  call s:init(#{ dir: $XDG_DATA_HOME.'/vim' })

  let g:packs = get(g:, 'packs', {})

  call s:add('vim')
  if has('nvim')
    call s:init(#{ dir: stdpath('data').'/site' })
    call s:add('neovim')
  endif

  call minpac#clean()
  call minpac#update()
endfunction
