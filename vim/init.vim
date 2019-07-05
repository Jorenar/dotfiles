" # Neovim #

" AUTOCMDS {{{

" Open file at the last known position
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif

" Disable continuation of comments to the next line
autocmd VimEnter * set fo-=c fo-=r fo-=o

" Trim trailing whitespace
autocmd BufWritePre * silent! undojoin | %s/\s\+$//e | %s/\(\n\r\?\)\+\%$//e

" Set tags file for C/C++
autocmd filetype c,cpp setlocal tags+=$HOME/.vim/tags/include.tags

" }}}

" COLORS {{{

" Enable syntax
syntax enable

" Set colorscheme
colorscheme black_and_white

" }}}

" COMMANDS {{{

command! -nargs=* Refactor call <SID>Refactor(<f-args>)
command! -nargs=+ FillLine call <SID>FillLine(<f-args>)
command! -nargs=+ Grep execute "vimgrep /".<f-args>."/j ** | :copen"
command! -nargs=+ Spelling execute 'setlocal spell spelllang=<args>'
command! -range -nargs=+ Align <line1>,<line2>!column -ts'<args>' -o'<args>'
command! -range -nargs=0 -bang VisSort sil! keepj <line1>,<line2>call <SID>VisSort(<bang>0)
command! -range=% Sort normal :<line1>,<line2>sort i<CR>
command! Debug normal :Termdebug<CR><C-w>H
command! ExecCurrentLine normal :.w !sh<CR>
command! GetPlugins call GetPlugins()
command! SortBlock :normal! vip:sort i<CR>

" }}}

" COMPILE AND RUN {{{

let s:compiler_for_filetype = {
            \ "c,cpp"    : "gcc",
            \ "go"       : "go",
            \ "haskell"  : "ghc",
            \ "html"     : "tidy",
            \ "perl"     : "perl",
            \ "php"      : "php",
            \ "plaintex" : "tex",
            \ "python"   : "pyunit",
            \ "tex"      : "tex",
            \}

let s:makeprg_for_filetype = {
            \ "asm"      : "as -o %<.o % && ld -s -o %< %<.o && rm %<.o && ./%<",
            \ "basic"    : "$HOME/app/vintbas %",
            \ "c"        : "gcc -std=gnu11 -g % -o %< && ./%<",
            \ "cpp"      : "g++ -std=gnu++11 -g % -o %< && ./%<",
            \ "go"       : "go build && ./%<",
            \ "haskell"  : "ghc -o %< %; rm %<.hi %<.o && ./%<",
            \ "html"     : "tidy -quiet -errors --gnu-emacs yes %:S; firefox -new-window %",
            \ "lisp"     : "clisp %",
            \ "lua"      : "lua %",
            \ "markdown" : "grip -b % 1> /dev/null",
            \ "nasm"     : "yasm -f elf64 % && ld -g -o %< %<.o && rm %<.o && ./%<",
            \ "perl"     : "perl %",
            \ "plaintex" : "pdftex -file-line-error -interaction=nonstopmode % && zathura %<.pdf",
            \ "python"   : "python3 %",
            \ "rust"     : "rustc % && ./%<",
            \ "sh"       : "chmod +x %:p && %:p",
            \ "tex"      : "pdflatex -file-line-error -interaction=nonstopmode % && zathura %<.pdf",
            \ "xhtml"    : "tidy -asxhtml -quiet -errors --gnu-emacs yes %:S; firefox -new-window %",
            \}

" }}}

" FOLDING METHODS {{{

let s:foldmethod_for_filetype = {
            \ "c,cpp"    : "syntax",
            \ "java"     : "syntax",
            \ "markdown" : "indent",
            \}

" }}}

" FORMATTING {{{

let s:tab_width_for_filetype = {
            \ "html,css,xhtml,xml" : 2,
            \ "javascript"         : 2,
            \ "markdown"           : 2,
            \}

let s:formatprg_for_filetype = {
            \ "c,cpp"      : "astyle --style=kr -s4 -N -S -xG -xU -f -k3 -xj -p",
            \ "css"        : "css-beautify -s 2",
            \ "go"         : "gofmt",
            \ "html"       : "tidy -q -w -i --show-warnings 0 --show-errors 0 --tidy-mark no",
            \ "java"       : "astyle --style=java -s4 -N -S -xG -xU -f -k3 -xj -p",
            \ "javascript" : "js-beautify -s 2",
            \ "json"       : "js-beautify",
            \ "python"     : "autopep8 -",
            \ "sql"        : "sqlformat -k upper -r -",
            \ "xhtml"      : "tidy -asxhtml -q -m -w -i --show-warnings 0 --show-errors 0 --tidy-mark no --doctype loose",
            \ "xml"        : "tidy -xml -q -m -w -i --show-warnings 0 --show-errors 0 --tidy-mark no",
            \}

" }}}

" FUNCTIONS {{{

" Fill line with characters to given column {{{
function! s:FillLine(str, ...) abort
    let to_column = get(a:, 1, &tw)
    let reps = (to_column - col("$")) / len(a:str)
    if reps > 0
        .s/$/\=(' '.repeat(a:str, reps))/
    endif
endfunction
" }}}

" Sorts lines based on visual-block selected portion of the lines {{{
function! s:VisSort(isnmbr) range abort
    if visualmode() != "\<c-v>"
        execute "silent! ".a:firstline.",".a:lastline."sort i"
        return
    endif
    let firstline = line("'<")
    let lastline  = line("'>")
    let keeprega  = @a
    silent normal! gv"ay
    '<,'>s/^/@@@/
    silent! keepjumps normal! '<0"aP
    if a:isnmbr
        silent! '<,'>s/^\s\+/\=substitute(submatch(0),' ','0','g')/
    endif
    execute "sil! keepj '<,'>sort i"
    execute "sil! keepj ".firstline.",".lastline.'s/^.\{-}@@@//'
    let @a = keeprega
endfun
" }}}

" Status line - file size {{{
function! FileSize() abort
    let bytes = getfsize(expand(@%))
    if (bytes >= 1024*1024)
        return '~' . float2nr(round(bytes/(1024*1024.0))) . ' MiB'
    elseif (bytes >= 1024)
        return '~' . float2nr(round(bytes/1024.0)) . ' KiB'
    elseif (bytes <= 0)
        return '0 B'
    else
        return bytes . ' B'
    endif
endfunction
" }}}

" Status line - file encoding {{{
function! FileEncoding() abort
    return (&fenc == "" ? &enc : &fenc).((exists("+bomb") && &bomb) ? " BOM" : "")
endfunction
" }}}

" Preview of Vim 256 colors {{{
function! Color_demo() abort
    30 vnew
    setlocal nonumber buftype=nofile bufhidden=hide noswapfile
    setlocal statusline=[%n]
    setlocal statusline+=\ Color\ demo
    let num = 255
    while num >= 0
        execute 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
        execute 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
        call append(0, 'ctermbg='.num.':....')
        let num = num - 1
    endwhile
endfunction
" }}}

" Check highlight group under the cursor {{{
function! WhatHighlightsIt() abort
    echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
                \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
                \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction
" }}}

" Replace through whole project {{{
function! s:Refactor(expr1, expr2) abort
    execute "vimgrep /\\C\\W".a:expr1."\\W/j ** | cdo s/\\C\\\(\\W\\)".a:expr1."\\\(\\W\\)/\\1".a:expr2."\\2/gc | update"
endfunction
" }}}

" Install and update plugins {{{

function! GetPlugins()
    for plugin in g:plugins
        let localrepo = $HOME.'/.config/nvim/pack/plugins/opt/'.substitute(plugin, ".*\/", "", "")
        let reposrc = "https://github.com/".plugin
        let cmd = "git clone ".reposrc." ".localrepo." 2> /dev/null || (cd ".localrepo." ; git pull)"
        call system(cmd)
        packadd plugin_name
    endfor
    echo "DONE"
endfunction

" }}}

" }}}

" MAPPINGS {{{

" leader
noremap <leader>= gg=G``
noremap <leader>q gggqG``
noremap <leader>h :nohlsearch<CR>
noremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
noremap <Leader>R :%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>
noremap <leader>v ggVG

" Function keys
inoremap <F1> <ESC>gT
inoremap <F2> <ESC>gt
noremap <F1> gT
noremap <F2> gt
noremap <F9> :w <bar> make<CR>

" Ctrl, shift, tab
inoremap <C-o> <C-x><C-o>
nnoremap <C-p> "+p
nnoremap <C-y> "+y
noremap <S-Tab> <C-w>W
noremap <Tab> <C-w><C-w>
xnoremap <C-y> "+y

" Normal keys
inoremap </ </<C-x><C-o>
noremap ' `
noremap '' ``
noremap gf <C-w>gf
noremap j gj
noremap k gk
noremap N Nzz
noremap n nzz

" <nop>
map gh <nop>
map q: <nop>
map ZZ <nop>
vmap s <nop>

" }}}

" OPTIONS {{{

" Displaying text/code {{{

set foldmethod=indent
set linebreak
set nofoldenable
set nowrap

" }}}

" Indentation {{{

let g:html_indent_style1 = "inc"
let g:html_indent_autotags = "html"
set autoindent
set cindent
set expandtab
set shiftround
set shiftwidth=4
set softtabstop=4
set tabstop=4

" }}}

" OTHER {{{

set backspace=indent,eol,start
set omnifunc=syntaxcomplete#Complete
set formatoptions-=t
set history=50
set lazyredraw
set modeline

" }}}

" Searching {{{

set hlsearch
set ignorecase
set incsearch
set smartcase

" }}}

" UI {{{

let g:netrw_winsize = -28
set colorcolumn=+1
set completeopt=longest,menuone
set cursorcolumn
set cursorline
set guicursor=
set laststatus=2
set number
set scrolloff=5
set shortmess+=I
set showcmd
set splitbelow
set splitright
set textwidth=79
set title
set wildmenu
set wildoptions-=pum

" }}}

" Vimfiles {{{

set backup
set backupdir=$HOME/.config/nvim/cache/backup/
set dictionary+=/usr/share/dict/polish
set dictionary+=/usr/share/dict/words
set noswapfile
set tags+=.git/tags
set undodir=$HOME/.config/nvim/cache/undo/
set undofile
set viminfo+=n$HOME/.config/nvim/viminfo

" }}}

" }}}

" PATH {{{

set path+=**
set path+=./
set path+=/usr/include
set path+=/usr/include/c++/7

" }}}

" PLUGINS {{{

let g:plugins = [
            \ "christoomey/vim-tmux-navigator",
            \ "mbbill/undotree",
            \ "sirver/ultisnips",
            \ "tpope/vim-surround",
            \]

" VARIABLES
let g:UltiSnipsEditSplit          = "context"
let g:UltiSnipsExpandTrigger      = "<C-j>"
let g:UltiSnipsListSnippets       = "<C-k>"
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators    = 1

" MAPPINGS
nmap s ys
noremap <leader><F1> :UndotreeToggle<CR>

" }}}

" QUICKFIX {{{

" Quit QuickFix window along with source file window
autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix" | q | endif

" QuickFix window below other windows
autocmd filetype qf wincmd J

" Automatically open QuickFix
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" MAPPINGS
autocmd filetype qf noremap <buffer> g- :colder<CR>
autocmd filetype qf noremap <buffer> g+ :cnewer<CR>

" }}}

" STATUS LINE {{{

set statusline=
set statusline+=\ %f                " Relative path to the file
set statusline+=\ \                 " Separator
set statusline+=%y                  " Filetype
set statusline+=[%{&ff}]            " File format
set statusline+=[%{FileEncoding()}] " File encoding
set statusline+=\ \                 " Separator
set statusline+=[%{&fo}]            " Format options
set statusline+=\ \                 " Separator
set statusline+=[%{FileSize()}]     " File size
set statusline+=\ \                 " Separator
set statusline+=%r                  " Readonly flag
set statusline+=%w                  " Preview flag
set statusline+=\ \                 " Separator
set statusline+=%m                  " Modified flag
set statusline+=%=                  " Switch to the right side
set statusline+=%l/                 " Current line
set statusline+=%L                  " Total lines
set statusline+=\ \:\ %c\           " Current column

" }}}

" ### OTHER {{{

" Add TermDebug
packadd termdebug

" Create cache files dirs
call mkdir($HOME.'/.config/nvim/cache/backup', 'p')
call mkdir($HOME.'/.config/nvim/cache/undo', 'p')

" Create plugins dir
call mkdir($HOME.'/.config/nvim/pack/plugins/opt', 'p')
call system('ln -sfn $HOME/.config/nvim/pack/plugins/opt $HOME/.config/nvim/plugins')

" TERMINAL BUFFER {{{

autocmd TermOpen * startinsert | setlocal nonumber

tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

" }}}

" Applying dictionaries loops {{{

for [ft, comp] in items(s:compiler_for_filetype)
    execute "autocmd filetype ".ft." compiler! ".comp
endfor

for [ft, mp] in items(s:makeprg_for_filetype)
    execute "autocmd filetype ".ft." let &l:makeprg=\"if [ -f \\\"Makefile\\\" ]; then make $*; else ".mp."; fi\""
endfor

for [ft, method] in items(s:foldmethod_for_filetype)
    execute "autocmd filetype ".ft." setlocal foldmethod=".method
endfor

for [ft, fp] in items(s:formatprg_for_filetype)
    execute "autocmd filetype ".ft." let &l:formatprg=\"".fp."\" | setlocal formatexpr="
endfor

for [ft, width] in items(s:tab_width_for_filetype)
    execute "autocmd filetype ".ft." setlocal tabstop=".width." shiftwidth=".width." softtabstop=".width
endfor

for plugin in g:plugins
    execute "packadd ".substitute(plugin, ".*\/", "", "")
endfor

" }}}

" }}}

" vim: fdm=marker foldenable:
