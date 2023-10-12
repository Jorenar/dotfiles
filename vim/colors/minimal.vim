set background=dark
highlight clear
if exists('syntax on') | syntax reset | endif
let g:colors_name='minimal'

hi! CursorLineNr     NONE
hi! SignColumn       NONE
hi! TabLine          NONE
hi! TabLineFill      NONE
hi! VertSplit        NONE

hi! DiffAdd          NONE  ctermfg=DarkGreen
hi! DiffChange       NONE  ctermfg=White
hi! DiffDelete       NONE  ctermfg=DarkRed
hi! DiffText         NONE  ctermfg=DarkCyan

hi! StatusLine       NONE  ctermfg=White
hi! StatusLineNC     NONE  ctermfg=DarkGray
hi! StatusLineTerm   NONE  ctermfg=Black ctermbg=LightGreen

hi! Search           NONE  ctermfg=Black ctermbg=DarkGray
hi! IncSearch        NONE  ctermfg=Black ctermbg=LightCyan

hi! ColorColumn      NONE  ctermbg=233
hi! CursorLine       NONE  ctermbg=233
hi! CursorColumn     NONE  ctermbg=233

hi! Pmenu            NONE  ctermbg=233
hi! PmenuSel         NONE  cterm=reverse

hi! Folded           NONE  cterm=bold,italic
hi! MatchParen       NONE  cterm=bold ctermfg=LightYellow
hi! NonText          NONE  ctermfg=DarkGray
hi! QuickFixLine     NONE  cterm=underline
hi! TabLineSel       NONE  cterm=bold  ctermfg=White
hi! WarningMsg       NONE  ctermfg=Black  ctermbg=DarkYellow
hi! WildMenu         NONE  cterm=reverse

hi! link FoldColumn  NonText
hi! link LineNr      NonText
