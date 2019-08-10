" Somethimes I just want to look how ugly was my colorscheme in the past

" Reset syntax highlighting
hi clear
if exists('syntax on')
    syntax reset
endif

" Declare theme name
let g:colors_name='old'


" THERE STARTS ACTUAL THEME ---------------------------------------------------

" Set background to dark
set background=dark

function! s:HighlightC_PreProcDefines()
    syntax clear C_PreProcDefine
    for line in getline('1','$')
        if line =~ '^\s*#\s*define\s\+'
            execute 'syntax keyword C_PreProcDefine '.substitute(line, '^\s*#\s*define\s\+\(\k\+\).*$', '\1', '')
        endif
    endfor
endfunction

" C/C++ preprocessor defined macros
autocmd filetype c,cpp autocmd VimEnter,InsertEnter,InsertLeave * call <SID>HighlightC_PreProcDefines()

" Operator Characters
autocmd filetype c,cpp syntax match OperatorChars display "?\|+\|-\|\*\|\^\|;\|:\|,\|<\|>\|&\||\|!\|\~\|%\|=\|)\|(\|{\|}\|\.\|\[\|\]\|/\(/\|*\)\@!"
autocmd BufReadPost * syntax match OperatorChars display "?\|+\|-\|\*\|\^\|;\|:\|,\|<\|>\|&\||\|!\|\~\|%\|=\|)\|(\|{\|}\|\.\|\[\|\]\|/\(/\|*\)\@!"

hi  C_PreProcDefine   ctermfg=DarkRed
hi  ColorColumn       ctermbg=magenta
hi  Comment           ctermfg=grey
hi  CursorColumn      ctermbg=235
hi  CursorLine        cterm=none
hi  CursorLineNr      ctermfg=magenta
hi  debugBreakpoint   ctermfg=black       ctermbg=red
hi  DiffAdd           ctermfg=LightGreen  ctermbg=none
hi  DiffChange        ctermfg=yellow      ctermbg=none
hi  DiffDelete        ctermfg=red         ctermbg=none     cterm=bold
hi  FoldColumn        ctermbg=black
hi  FoldMarker        ctermfg=cyan        cterm=bold,underline
hi  LineNr            ctermfg=242
hi  Normal            ctermfg=grey
hi  Number            ctermfg=DarkCyan
hi  OperatorChars     ctermfg=3
hi  Pmenu             ctermfg=black       ctermbg=cyan
hi  PmenuSel          ctermfg=black       ctermbg=blue
hi  PreProc           ctermfg=LightGreen
hi  QuickFixLine      ctermbg=NONE        cterm=underline
hi  SignColumn        ctermbg=black
hi  Special           ctermfg=red         ctermbg=black
hi  StatusLine        ctermfg=black       ctermbg=yellow   cterm=NONE
hi  StatusLineNC      ctermfg=white
hi  String            ctermfg=DarkCyan
hi  Type              ctermfg=white
hi  VimCommentString  ctermfg=grey
hi  WildMenu          ctermbg=cyan
