" XDG variables {{{
if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME."/.cache"       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME."/.config"      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME."/.local/share" | endif
if empty($XDG_STATE_HOME)  | let $XDG_STATE_HOME  = $HOME."/.local/state" | endif
" }}}

" $VIM/vimfiles {{{
if executable('vim')
  let s:VIM = trim(system('env -i vim --clean -es +"!echo \$VIM" +q'))
  if !v:shell_error
    let &rtp = substitute(&rtp,
          \ $VIMRUNTIME.'\>',
          \ s:VIM.'/vimfiles' . ',&,' . s:VIM.'/vimfiles/after',
          \ '')
  endif
  unlet s:VIM
endif
" }}}

" Source Vim config {{{

function! s:InjectVimXdgPaths(var, xdg, ...) abort
  let dir = get(a:, 1, '')
  let pat = a:xdg.'/nvim'.(a:xdg == $XDG_DATA_HOME ? "/site" : '').dir
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

lua require('vimterm').setup({})

autocmd TermOpen * setl nonu fdc=0 scl=no
autocmd TermOpen * setl stl=%#StatusLineTerm#\ %f
autocmd TermClose * call feedkeys("\<C-\>\<C-n>")

" }}}

lua require("flatten").setup({
      \   window = {
      \     open = "split"
      \   }
      \ })

set backupdir-=.
set guicursor=a:block
set startofline

let &grepformat = "%f:%l:%m,%f:%l%m,%f  %l%m"

autocmd! nvim_swapfile

let g:ale_use_neovim_diagnostics_api = 0
