setl spell
setl fo+=w
setl textwidth=71
setl colorcolumn=+2
setl nomodeline
setl noexpandtab
setl foldmethod=syntax

let no_mail_maps = 1

let b:trimWhitespace_pattern = ' \zs\s\+$'

autocmd BufWinEnter <buffer> ++once setlocal syntax=mail


if bufname("%") =~# 'aerc-'
  nnoremap <Leader>; :
  nnoremap gt <Cmd>silent !aerc :next-tab<CR><Cmd>redraw!<CR>
  nnoremap gT <Cmd>silent !aerc :prev-tab<CR><Cmd>redraw!<CR>

  if bufname("%") =~# 'aerc-view'
    setl colorcolumn=
    setl laststatus=1
    setl nospell
    setl showtabline=1
    setl signcolumn=no
  elseif bufname("%") =~# 'aerc-compose'
    function! AercEx() abort
      silent !xdotool key alt+Delete
      redraw!
    endfunction
    nnoremap <Leader>: :<C-u>call AercEx()
  endif
endif
