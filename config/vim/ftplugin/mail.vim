setl fo+=w
setl textwidth=71
setl colorcolumn=+1
setl nomodeline
setl noexpandtab
setl foldmethod=syntax

if !executable("vale")
  setl spell
endif

let no_mail_maps = 1

let b:trimWhitespace_pattern = ' \zs\s\+$'

autocmd BufWinEnter <buffer> ++once setlocal syntax=on

let b:ale_enabled = &modifiable && !&readonly


if bufname("%") =~# 'aerc-'
  if exists('$WAYLAND_DISPLAY')
    nnoremap <Leader>: <Cmd>silent !wtype -M alt -P delete<CR><Cmd>redraw!<CR>
  else
    function! AercEx() abort
      silent !xdotool key alt+Delete
      redraw!
    endfunction
    nnoremap <Leader>: :<C-u>call AercEx()<Esc>
    autocmd CmdlineChanged * if getcmdline() =~ 'call AercEx' | call AercEx() | endif
  endif

  nnoremap gt <Cmd>silent !aerc :next-tab<CR><Cmd>redraw!<CR>
  nnoremap gT <Cmd>silent !aerc :prev-tab<CR><Cmd>redraw!<CR>

  if bufname("%") =~# 'aerc-view'
    setl colorcolumn=
    setl laststatus=1
    setl nolist
    setl nospell
    setl showtabline=1
    setl signcolumn=no

    autocmd VimLeavePre * silent !aerc :close
  endif

  if bufname("%") =~# 'aerc-compose'
    autocmd BufWinEnter <buffer>
          \ | silent! 1,/^From:/ s/\VFrom:\zs <\.@\.>//
          \ | silent! 1,/^Subject:/ s/\cRe:.*\zsRe: \ze//
          \ | silent! %s/\v%(^\>[ \>]*)@<= \>/>/g
          \ | silent! %s/^>\+\zs \+$//
          \ | silent! %s/\s\{2,}$//
          \ | silent! %s/’/'/g
          \ | norm! gg
  endif
endif


function! AddrComplete(findstart, base) abort
  if a:findstart
    return match(getline('.')[0 : col('.')-2], '\v<\S+$')
  endif

  let lines = []
  if filereadable($XDG_DATA_HOME.'/addressbook.txt')
    let lines += readfile($XDG_DATA_HOME.'/addressbook.txt')
          \ ->filter({_,l -> l !~ '^\s*#'})
          \ ->filter({_,l -> l =~ a:base})
  endif
  if executable('notmuch-addrlookup')
    silent let lines += systemlist('notmuch-addrlookup' . " '" . a:base . "'")
  endif

  let results = []
  for line in lines
    if empty(trim(line)) | continue | endif

    let words = split(line, ' \ze<')
    let name = substitute(words[0], '\v^"|"$', '', 'g')
    let address = substitute(words[len(words) < 2 ? 0 : 1], '[<>]', '', 'g')

    if name == address
      if indexof(results, {_,v -> v.menu == '<'.address.'>'}) >= 0
        continue
      endif
    endif

    call add(results, {
          \   'word': name . ' <' . address . '>',
          \   'abbr': strlen(name) < 35 ? name : name[0:30] . '...',
          \   'menu': '<' . address . '>',
          \ })
  endfor

  return uniq(results, 'i')
endfunction

command! AddrBook vnew $XDG_DATA_HOME/addressbook.txt
setlocal omnifunc=AddrComplete
