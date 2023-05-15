" trimWhitespace
" Maintainer:  Jorengarenar <https://joren.ga>

if exists('g:loaded_trimWhitespace') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

function! s:getVar(var) abort
  let var = "trimWhitespace_" . a:var
  return get(b:, var, get(g:, var, eval('s:'.a:var)))
endfunction


let s:enabled  = 1
let s:at_eof   = 1
let s:pattern  = '\s\+$'

let s:diff_binary = executable("diff.exe") ? "diff.exe" : "command diff"
" !! GNU diff required !!
let s:diff_cmd = s:getVar("diff_binary")
      \ . ' --unchanged-group-format="" --old-group-format=""'
      \ . ' --new-group-format="%dF,%dL " --changed-group-format="%dF,%dL " '


function! s:TrimWhitespace() abort
  if !s:getVar('enabled') | return | endif

  let l:changes = []

  if !filereadable(expand('%'))
    let l:changes = "1,".line('$')
  elseif &modified
    redir => l:changes
    silent! echo system(
          \   s:diff_cmd . ' ' . shellescape(expand('%')) . ' -',
          \   join(getline(1, line('$')), "\n") . "\n"
          \ )
    redir END
  endif

  if empty(l:changes) | return | endif

  let l:pos = getpos('.')

  let l:fmt_eol = 'keepp keepj %s s/' . s:getVar("pattern") . '//e'
  for l:range in split(l:changes)
    silent execute printf(l:fmt_eol, l:range)
  endfor

  if s:getVar('at_eof') && split(l:range, ',')[1] >= line('$')
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
