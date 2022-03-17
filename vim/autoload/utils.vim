function! utils#upper(k)
  if synIDattr(synID(line('.'), col('.')-1, 0), "name") !~# 'Comment\|String'
    return toupper(a:k)
  else
    return a:k " was comment or string, so don't change case
  endif
endfunction

function! utils#appendToSynRule(group, addition) abort
  let rule = execute("silent syntax list " . a:group)
  let type = rule =~ "\<match\>" ? "match" : "region"
  exec "silent syntax clear" a:group
  let args = matchstr(rule, '\v.*<xxx\s+%(match>)?\zs.+\ze%(<links to .*)?')
  let args = substitute(args, '\_s\+', ' ', 'g')
  exec "silent syntax" type a:group args a:addition
endfunction

function! utils#CountSpell() abort
  let [ pos, spell_old, ws_old, lz_old ] = [ getpos('.'), &spell, &ws, &lz ]
  let [ &spell, &ws, &lz ] = [ 1, 0, 1 ]

  let [ counter, prev_pos ] = [ 0, pos ]
  normal! gg0

  while 1
    normal! ]S
    if getpos(".") == prev_pos | break | endif
    let [ counter, prev_pos ] = [ counter+1, getpos('.') ]
  endwhile

  call setpos('.', pos)
  let [ &spell, &ws, &lz ] = [ spell_old, ws_old, lz_old ]

  return counter
endfunction

function! utils#VisSort() range abort " sorts based on visual-block selected portion of the lines
  if visualmode() != "\<C-v>"
    exec "sil! ".a:firstline.",".a:lastline."sort i"
    return
  endif
  let [ firstline, lastline ] = [ line("'<"), line("'>") ]
  let old_a  = @a
  silent normal! gv"ay
  '<,'>s/^/@@@/
  silent! keepjumps normal! '<0"aP
  silent! keepj '<,'>sort i
  execute "sil! keepj ".firstline.",".lastline.'s/^.\{-}@@@//'
  let @a = old_a
endfun

function! utils#InstallPlugins() abort
  let dir = substitute(&packpath, ",.*", "", "")."/pack/plugins/start/"
  silent! call mkdir(dir, 'p')
  call system("git init ".dir)

  for plugin in g:plugins.repos
    call system("git -C ".dir." submodule add --depth=1 https://github.com/".plugin)
  endfor
  call system("git -C ".dir." submodule update --recursive --remote")

  for f in g:plugins.files
    call system("curl -o ".substitute(&rtp, ",.*", "", "")."/".f[0]." -L ".f[1])
  endfor

  silent! helptags ALL
  echo "Plugins installed"
endfunction

function! utils#VSetSearch(cmdtype) abort " search for selected text, forwards or backwards
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

function! utils#TermEF(cmd) abort
  let errorsfile = tempname()

  let cmd  = expandcmd(a:cmd)
  let cmd .= " 2>&1 "
  let cmd .= has('nvim') ? "\\|" : "\|"
  let cmd .= " tee ".errorsfile

  if has('nvim')
    execute "term://".cmd
    augroup OPEN_ERROR_FILE
      autocmd!
      autocmd TermOpen  <buffer> let b:term_job_finished = 0
      autocmd TermEnter <buffer> if  b:term_job_finished | call feedkeys("\<C-\>\<C-n>") | endif
      execute "autocmd TermLeave <buffer> if !b:term_job_finished | cfile ".errorsfile." | endif"

      execute 'autocmd TermClose <buffer> let b:term_job_finished = 1 | call feedkeys("\<C-\>\<C-n>") | cfile '. errorsfile .' | copen'
    augroup END
  else
    tabe
    call term_start([ &shell, '-c', expandcmd(cmd) ], #{
          \   curwin:  1,
          \   exit_cb: { -> execute("cfile ".errorsfile." | cwindow") },
          \ })
  endif

  setlocal switchbuf=usetab
endfunction
