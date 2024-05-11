" XDG variables {{{
if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME."/.cache"       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME."/.config"      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME."/.local/share" | endif
if empty($XDG_STATE_HOME)  | let $XDG_STATE_HOME  = $HOME."/.local/state" | endif
" }}}

" Source Vim config {{{

function! s:InjectVimXdgPaths(var, xdg, ...) abort
  let dir = get(a:, 1, '')
  let pat = a:xdg.'/nvim'.dir
  let sub = a:xdg.'/vim'.dir
  let sub = (dir == '/after') ? (sub . ',' . pat) : (pat . ',' . sub)
  let pat = pat . '\v(/)@!'
  let val = trim(execute('echo &'.a:var))
  let val = substitute(val, pat, sub, 'g')
  exec 'let &'.a:var.' = val'
endfunction

call s:InjectVimXdgPaths('rtp', $XDG_CONFIG_HOME)
call s:InjectVimXdgPaths('rtp', $XDG_DATA_HOME)
call s:InjectVimXdgPaths('rtp', $XDG_DATA_HOME)
call s:InjectVimXdgPaths('rtp', $XDG_CONFIG_HOME, '/after')

call s:InjectVimXdgPaths('pp', $XDG_DATA_HOME)
call s:InjectVimXdgPaths('pp', $XDG_CONFIG_HOME)
call s:InjectVimXdgPaths('pp', $XDG_CONFIG_HOME, '/after')
call s:InjectVimXdgPaths('pp', $XDG_DATA_HOME, '/after')

so $XDG_CONFIG_HOME/vim/vimrc

" }}}

" :terminal {{{

function! s:NormalizeTerm() abort
  setlocal stl=%#StatusLineTerm#\ %f
  setlocal nonumber
  setlocal foldcolumn=0
  setlocal signcolumn=no

  if histget(':', -1) =~# '\v<%(vert%[ical]|hor%[izontal])\s+te%[rminal]>'
    startinsert
  else
    exec "e # | sb" bufnr()
    autocmd WinResized * ++once wincmd j | call feedkeys("A")
  endif
endfunction

autocmd TermOpen * call s:NormalizeTerm()
autocmd TermClose * call feedkeys("\<C-\>\<C-n>")

tnoremap <silent> <C-w>h  <Cmd>TmuxNavigateLeft<CR>
tnoremap <silent> <C-w>j  <Cmd>TmuxNavigateDown<CR>
tnoremap <silent> <C-w>k  <Cmd>TmuxNavigateUp<CR>
tnoremap <silent> <C-w>l  <Cmd>TmuxNavigateRight<CR>

tnoremap <silent> <C-w><C-h>  <Cmd>TmuxNavigateLeft<CR>
tnoremap <silent> <C-w><C-j>  <Cmd>TmuxNavigateDown<CR>
tnoremap <silent> <C-w><C-k>  <Cmd>TmuxNavigateUp<CR>
tnoremap <silent> <C-w><C-l>  <Cmd>TmuxNavigateRight<CR>

" }}}

set backupdir-=.
set guicursor=a:block
