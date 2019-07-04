" ################
" ### NEOVIMRC ###
" ################

" BASIC {{{

" Enable syntax
syntax enable

" Set colorscheme
colorscheme black_and_white

" }}}

" AUTOCMDS {{{

" Open file at the last known position
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif

" Disable continuation of comments to the next line
autocmd VimEnter * set fo-=c fo-=r fo-=o

" Trim trailing whitespace
autocmd BufWritePre * silent! undojoin | %s/\s\+$//e | %s/\(\n\r\?\)\+\%$//e

" Clear all maches after leaving buffer
autocmd BufWinLeave * call clearmatches()

" Set tags file for C/C++
autocmd filetype c,cpp setlocal tags+=$HOME/.vim/tags/include.tags

" }}}

" COMMANDS {{{

command! -nargs=* Refactor call <SID>Refactor(<f-args>)
command! -nargs=+ FillLine call <SID>FillLine(<f-args>)
command! -nargs=+ Grep execute "vimgrep /".<f-args>."/j ** | :copen"
command! -nargs=+ Spelling execute 'setlocal spell spelllang=<args>'
command! -range -nargs=0 -bang Vissort sil! keepj <line1>,<line2>call <SID>VisSort(<bang>0)
command! -range=% Sort normal :<line1>,<line2>sort i<CR>
command! Debug normal :Termdebug<CR><C-w>H
command! ExecCurrentLine normal :.w !sh<CR>
command! FileSize echo getfsize(expand(@%))
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

" VARIABLES {{{

let s:copy_command  = 'xsel --clipboard --input'
let g:CursorHighlight_state = 0
let s:paste_command = 'xsel --clipboard --output'

" }}}

" Fill line with characters to given column {{{
function! s:FillLine(str, ...) abort
    let to_column = get(a:, 1, &tw)
    let reps = (to_column - col("$")) / len(a:str)
    if reps > 0
        .s/$/\=(' '.repeat(a:str, reps))/
    endif
endfunction
" }}}

" Toggle cursorline highlight {{{
function! s:CursorHighlightToggle() abort
    if (g:CursorHighlight_state == 1)
        hi CursorLine cterm=none ctermbg=none
        let g:CursorHighlight_state = 0
    else
        hi CursorLine cterm=none ctermbg=235
        let g:CursorHighlight_state = 1
    endif
    echo
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

" System copy function if Vim does not have 'clipboard' support {{{
function! s:system_copy(type, ...) abort
    let visual_mode = a:0 != 0
    if visual_mode
        let mode = (a:type == '') ?  'blockwise visual' : 'visual'
    elseif a:type == 'line'
        let mode = 'linewise'
    else
        let mode = 'motion'
    endif
    let unnamed = @@
    if mode == 'linewise'
        let lines = { 'start': line("'["), 'end': line("']") }
        silent exe lines.start . "," . lines.end . "y"
    elseif mode == 'visual' || mode == 'blockwise visual'
        silent exe "normal! `<" . a:type . "`>y"
    else
        silent exe "normal! `[v`]y"
    endif
    let command = s:copy_command
    silent call system(command, getreg('@'))
    let @@ = unnamed
endfunction
" }}}

" System paste function if Vim does not have 'clipboard' support {{{
function! s:system_paste() abort
    let lines = system('xsel --clipboard --output | wc -l')
    if lines == 0
        execute "normal! a".system(s:paste_command)
    else
        put = system(s:paste_command)
    endif
endfunction
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

" Refactor {{{
function! s:Refactor(expr1, expr2) abort
    execute "vimgrep /\\C\\W".a:expr1."\\W/j ** | cdo s/\\C\\\(\\W\\\)".a:expr1."\\\(\\W\\\)/\\1".a:expr2."\\2/gc | update"
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
noremap <F3> :call <SID>CursorHighlightToggle()<CR>
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
set cursorline
set guicursor=
set laststatus=2
set number
set scrolloff=5
set shortmess+=I
set showcmd
set signcolumn=yes
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
set undodir=$HOME/.config/nvim/cache/undo/
set undofile
set viminfo+=n$HOME/.config/nvim/viminfo

" }}}

" OTHER {{{

set backspace=indent,eol,start
set omnifunc=syntaxcomplete#Complete
set formatoptions-=t
set history=50
set lazyredraw
set modeline

" }}}

" }}}

" OTHER {{{

" Add TermDebug
packadd termdebug

" Create cache files dirs
call mkdir($HOME.'/.config/nvim/cache/backup', 'p')
call mkdir($HOME.'/.config/nvim/cache/undo', 'p')

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

" }}}

" }}}

" PATH {{{

set path+=**
set path+=./
set path+=/usr/include
set path+=/usr/include/c++/7

" }}}

" PLUGINS {{{

" DOWNLOAD VIM-PLUG (if is not installed)
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl --create-dirs -fLo ~/.config/nvim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" INSTALL PLUGINS (via Plug)
call plug#begin()
Plug 'ludovicchabant/vim-gutentags'    " Gutentags
Plug 'tpope/vim-surround'              " Surround
Plug 'godlygeek/tabular'               " Tabular
Plug 'christoomey/vim-tmux-navigator'  " Tmux Navigator
Plug 'SirVer/ultisnips'                " UltiSnips
Plug 'mbbill/undotree'                 " UndoTree
call plug#end()

" VARIABLES
let g:gutentags_cache_dir         = $HOME."/.config/nvim/cache/tags"   "  Gutentags
let g:UltiSnipsEditSplit          = "context"                          "  UltiSnips
let g:UltiSnipsExpandTrigger      = "<C-j>"                            "  UltiSnips
let g:UltiSnipsListSnippets       = "<C-k>"                            "  UltiSnips
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']  "  UltiSnips
let g:undotree_SetFocusWhenToggle = 1                                  "  UndoTree
let g:undotree_ShortIndicators    = 1                                  "  UndoTree

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

" Disable cursorline highlight for QuickFix
autocmd filetype qf setlocal nocursorline

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

" vim: fdm=marker foldenable:
