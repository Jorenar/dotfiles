" trimWhitespace
" Author: Jorengarenar

if exists('g:loaded_trimWhitespace') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

function! s:getVar(var) abort
  let var = "trimWhitespace_" . a:var
  return get(b:, var, get(g:, var, eval('s:'.a:var)))
endfunction

" Default values for variables
let s:enabled  = 1
let s:nl_eof   = 1
let s:pattern  = '\s\+$'


function! s:NumsToRanges(list)
  let ranges = []
  let [ range_start, range_end ] = [ a:list[0], a:list[0] ]

  for l in a:list[1:]
    if l != range_end + 1
      let ranges += [ range_start . ',' . range_end ]
      let range_start = l
    endif
    let range_end = l
  endfor
  let ranges += [ range_start . ',' . range_end ]

  return ranges
endfunction

function! s:GetChanges() abort
  let gT = (tabpagenr() != tabpagenr('$'))
  sil! tab split
  sil! vnew | set buftype=nofile | sil! read ++edit # | sil! 0 delete _
  sil! windo diffthis

  wincmd p
  let [ dip_old, &dip ] = [ &diffopt, '' ]
  let diff_lines = range(1, line('$'))->filter({_, v ->
        \   diff_hlID(v, 1)->synIDattr('name') =~# 'Diff*'
        \ })
  let &dip = dip_old

  wincmd p
  bdelete | tabclose
  if gT | tabprevious | endif

  return empty(diff_lines) ? [] : s:NumsToRanges(diff_lines)
endfunction

function! s:TrimWhitespace() abort
  if !s:getVar('enabled') | return | endif

  let l:changes = ""

  if !filereadable(expand('%'))
    let l:changes = [ '1,'.line('$') ]
  elseif &modified
    let l:changes = s:GetChanges()
  endif

  if empty(l:changes) | return | endif

  let l:pos = getpos('.')

  let l:fmt_eol = 'keepp keepj %s s/' . s:getVar("pattern") . '//e'
  for l:range in l:changes
    silent execute printf(l:fmt_eol, l:range)
  endfor

  if s:getVar('nl_eof') && split(l:range, ',')[1] >= line('$')
    silent execute 'keepp keepj %s/\n\+\%$//e'
  endif

  call setpos('.', l:pos)
endfunction


augroup TRIM_TRAILING_WHITESPACE
  autocmd!
  autocmd BufWritePre * if &modifiable | call s:TrimWhitespace() | endif
augroup END


let g:loaded_trimWhitespace = 1
let &cpo = s:cpo_save | unlet s:cpo_save
