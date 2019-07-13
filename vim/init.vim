" # Neovim #

" AUTOCMDS {{{1

" Open file at the last known position
autocmd BufReadPost * normal! `"

" Disable continuation of comments to the next line
autocmd VimEnter * set fo-=c fo-=r fo-=o

" Trim trailing whitespace
autocmd BufWritePre * silent! undojoin | %s/\s\+$//e | %s/\(\n\r\?\)\+\%$//e

" Terminal buffer options
autocmd TermOpen * startinsert | setlocal nonumber nocursorcolumn nocursorline matchpairs=

" Set PATH for C/C++
autocmd filetype c,cpp setlocal path+=/usr/include/**

" Set tags file for C/C++
autocmd filetype c,cpp setlocal tags+=$HOME/.vim/tags/include.tags

" Set 'foldmethod' to 'syntax' for C/C++/Java
autocmd filetype c,cpp,java setlocal foldmethod=syntax

" shell script folding
autocmd filetype sh setlocal foldmethod=syntax | let g:sh_fold_enabled=5

" Quit QuickFix window along with source file window
autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix" | q | endif

" QuickFix window below other windows
autocmd filetype qf wincmd J

" Automatically open QuickFix
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" QuckFix's mappings
autocmd filetype qf noremap <buffer> g- :colder<CR>
autocmd filetype qf noremap <buffer> g+ :cnewer<CR>

" COMMANDS {{{1

command! -nargs=* GrepRename call <SID>GrepRename(<f-args>)
command! -nargs=+ FillLine call <SID>FillLine(<f-args>)
command! -nargs=+ Grep execute "vimgrep /".<f-args>."/j ** | :copen"
command! -nargs=+ Spelling execute 'setlocal spell spelllang=<args>'
command! -range -nargs=+ Align <line1>,<line2>!column -Lts'<args>' -o'<args>'
command! -range -nargs=0 -bang VisSort sil! keepj <line1>,<line2>call <SID>VisSort(<bang>0)
command! -range=% Sort normal :<line1>,<line2>sort i<CR>
command! Debug normal :Termdebug<CR><C-w>H
command! ExecCurrentLine normal :.w !sh<CR>
command! GetPlugins call GetPlugins()
command! SortBlock :normal! vip:sort i<CR>

" COMPILE AND RUN {{{1

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

" FORMATTING {{{1

let g:html_indent_autotags = "html"
let g:html_indent_style1 = "inc"
set autoindent
set cindent
set expandtab
set formatoptions-=t
set shiftround
set shiftwidth=4
set softtabstop=4
set tabstop=4
set textwidth=79

let s:tab_width_for_filetype = {
            \ "html,css,xhtml,xml" : 2,
            \ "javascript"         : 2,
            \ "lua"                : 2,
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

" FUNCTIONS {{{1

" Color_demo - preview of Vim 256 colors {{{2
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

" GetPlugins - install and update plugins {{{2
function! GetPlugins()
    for plugin in g:plugins
        let plugin_name = substitute(plugin, ".*\/", "", "")
        let plugin_dir = $HOME.'/.config/nvim/pack/plugins/opt/'.plugin_name
        let github_url = "https://github.com/".plugin
        let cmd = "git clone ".github_url." ".plugin_dir." 2> /dev/null || (cd ".plugin_dir." ; git pull)"
        call system(cmd)
        execute "packadd ".plugin_name
        execute "helptags ".plugin_dir."/doc"
    endfor
    echo "DONE"
endfunction

" GrepRename - replace through whole project {{{2
function! s:GrepRename(expr1, expr2) abort
    execute "vimgrep /\\C\\W".a:expr1."\\W/j ** | cdo s/\\C\\\(\\W\\)".a:expr1."\\\(\\W\\)/\\1".a:expr2."\\2/gc | update"
endfunction

" FileEncoding ~ for Status line {{{2
function! FileEncoding() abort
    return (&fenc == "" ? &enc : &fenc).((exists("+bomb") && &bomb) ? " BOM" : "")
endfunction

" FileSize     ~ for Status Line{{{2
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

" FillLine - fill line with characters to given column {{{2
function! s:FillLine(str, ...) abort
    let to_column = get(a:, 1, &tw)
    let reps = (to_column - col("$")) / len(a:str)
    if reps > 0
        .s/$/\=(' '.repeat(a:str, reps))/
    endif
endfunction

" TmuxAwareNavigate {{{2
function! TmuxAwareNavigate(direction)
    let nr = winnr()
    execute 'wincmd ' . a:direction
    if (nr == winnr())
        let args = 'select-pane -t ' . shellescape($TMUX_PANE) . ' -' . tr(a:direction, 'phjkl', 'lLDUR')
        silent call system('tmux' . ' -S ' . split($TMUX, ',')[0] . ' ' . args)
    else
    endif
endfunction

" VisSort - sorts based on visual-block selected portion of the lines {{{2
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

" WhatHighlightsIt - check highlight group under the cursor {{{2
function! WhatHighlightsIt() abort
    echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
                \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
                \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction
" }}}

" MAPPINGS {{{1

" All modes {{{2
noremap ' `
noremap '' ``
noremap <F1> gT
noremap <F2> gt
noremap <F9> :w <bar> make<CR>
noremap <leader>h :nohlsearch<CR>
noremap <leader>v ggVG
noremap <S-Tab> <C-w>W
noremap <Tab> <C-w><C-w>
noremap gf <C-w>gf
noremap j gj
noremap k gk

" Normal mode {{{2
nnoremap <C-p> "+p
nnoremap <C-y> "+y
nnoremap <leader>= gg=G``
nnoremap <leader>q gggqG``
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>R :%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>
nnoremap <silent> <C-h> :call TmuxAwareNavigate('h')<CR>
nnoremap <silent> <C-j> :call TmuxAwareNavigate('j')<CR>
nnoremap <silent> <C-k> :call TmuxAwareNavigate('k')<CR>
nnoremap <silent> <C-l> :call TmuxAwareNavigate('l')<CR>

" Insert mode {{{2
inoremap </ </<C-x><C-o>
inoremap <C-o> <C-x><C-o>

" Terminal mode {{{2
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
tnoremap <Esc> <C-\><C-n>

" Visual mode {{{2
xnoremap <C-y> "+y

" ### DISABLE {{{2
map gh <nop>
vmap s <nop>
map ZZ <nop>

"}}}

" OPTIONS {{{1

let g:netrw_winsize = -28
set backup
set colorcolumn=+1
set completeopt=menuone,noinsert,noselect
set cursorcolumn
set cursorline
set foldmethod=indent
set ignorecase
set incsearch
set lazyredraw
set linebreak
set modeline
set nofoldenable
set noswapfile
set nowrap
set number
set omnifunc=syntaxcomplete#Complete
set scrolloff=5
set shortmess+=I
set showcmd
set smartcase
set splitbelow
set splitright
set title
set undofile
set wildmenu
set wildoptions-=pum

" Dirs, tags, path
set backupdir=$HOME/.config/nvim/backup/
set dictionary+=/usr/share/dict/polish
set dictionary+=/usr/share/dict/words
set path=**,./
set tags+=.git/tags;/
set undodir=$HOME/.config/nvim/undo/

" PLUGINS {{{1

" Run :GetPlugins to install/update
let g:plugins = [
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
vmap s S

" STATUS LINE {{{1

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

" ### OTHER {{{1

" Enable syntax
syntax enable

" Set colorscheme
colorscheme black_and_white

" Add TermDebug
packadd termdebug

" Create cache files dirs
call mkdir(&backupdir, 'p')
call mkdir(&undodir, 'p')

" Create plugins dir
call mkdir($HOME.'/.config/nvim/pack/plugins/opt', 'p')

" Applying rules form arrays/dictionaries {{{

for [ft, comp] in items(s:compiler_for_filetype)
    execute "autocmd filetype ".ft." compiler! ".comp
endfor

for [ft, mp] in items(s:makeprg_for_filetype)
    execute "autocmd filetype ".ft." let &l:makeprg=\"if [ -f \\\"Makefile\\\" ]; then make $*; else ".mp."; fi\""
endfor

for [ft, fp] in items(s:formatprg_for_filetype)
    execute "autocmd filetype ".ft." let &l:formatprg=\"".fp."\" | setlocal formatexpr="
endfor

for [ft, width] in items(s:tab_width_for_filetype)
    execute "autocmd filetype ".ft." setlocal tabstop=".width." shiftwidth=".width." softtabstop=".width
endfor

for plugin in g:plugins
    execute "silent! packadd! ".substitute(plugin, ".*\/", "", "")
endfor

" }}}

" vim: fdm=marker foldenable:
