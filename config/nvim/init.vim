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

lua require('vimterm').setup({ autoclose = false })
lua require("flatten").setup({ window = { open = "split" } })

autocmd TermOpen * setl nonu fdc=0 scl=no
autocmd TermOpen * setl stl=%#StatusLineTerm#\ %f
autocmd TermClose * call feedkeys("\<C-\>\<C-n>")

" }}}

" diagnostics {{{

lua vim.diagnostic.config({
      \   signs = false,
      \   virtual_text = false,
      \ })

hi! link DiagnosticUnderlineError ALEError
hi! link DiagnosticUnderlineHint  ALEInfo
hi! link DiagnosticUnderlineInfo  ALEInfo
hi! link DiagnosticUnderlineWarn  ALEWarning

" }}}

" fzf-lua {{{

lua require("fzf-lua").setup({
      \   fzf_opts = {
      \     ["--cycle"] = true,
      \     ["--no-color"] = true,
      \   },
      \   previewers = { builtin = { syntax = false } },
      \   winopts = { treesitter = false },
      \
      \   oldfiles = {
      \     cwd_only = true,
      \     include_current_session = true,
      \   },
      \ })

nnoremap <Leader>f <Cmd>FzfLua<CR>
nnoremap <Leader>F <Cmd>FzfLua resume<CR>
nnoremap <Leader>t <Cmd>FzfLua btags resume=true<CR>
nnoremap <C-p><C-p> <Cmd>FzfLua files<CR>
nnoremap <C-p><C-m> <Cmd>FzfLua oldfiles<CR>

" }}}

lua require("mason").setup()

aunmenu PopUp.Paste
aunmenu PopUp.Select\ All
aunmenu PopUp.Inspect
aunmenu PopUp.-1-
aunmenu PopUp.How-to\ disable\ mouse

set backupdir-=.
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m
set noautoread
set notermguicolors
set startofline

hi! link FloatBorder NormalFloat

exec has('nvim-0.11') ? 'au! nvim.swapfile' :
      \ has('nvim-0.10') ? 'au! nvim_swapfile' : ''

lua require("cscope_maps").setup({
      \   disable_maps = true,
      \   cscope = { db_file = '' },
      \ })

runtime! init.d/*
