setl spell
setl fo+=w
setl textwidth=71
setl colorcolumn=+2
setl nomodeline
setl noexpandtab
autocmd BufWinEnter <buffer> ++once setlocal syntax=mail

let b:trimWhitespace_pattern = ' \zs\s\+$'

let no_mail_maps = 1

augroup AERC
  function! AercEx() abort
    silent !xdotool key alt+Delete
    redraw!
  endfunction

  autocmd!
  autocmd BufWinEnter *aerc-compose* set showtabline=1
  autocmd BufWinEnter *aerc-compose* nnoremap <Leader>: :<C-u>call AercEx()

  autocmd BufWinEnter *aerc-compose*
        \ nnoremap gt <Cmd>silent !aerc :next-tab<CR><Cmd>redraw!<CR>
  autocmd BufWinEnter *aerc-compose*
        \ nnoremap gT <Cmd>silent !aerc :prev-tab<CR><Cmd>redraw!<CR>
augroup END
