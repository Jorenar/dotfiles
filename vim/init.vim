" ################
" ### INIT.VIM ###
" ################

" USE ~/.vimrc {{{

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source $HOME/.vimrc

" }}}

" OPTIONS
set guicursor=
set wildoptions-=pum


" TERMINAL BUFFER -------------------------------------------------------------

autocmd TermOpen * startinsert | setlocal nonumber

tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

" vim: fdm=marker foldenable:
