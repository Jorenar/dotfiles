set background=dark
highlight clear
if has('nvim') | runtime! colors/vim.lua | endif
if exists('syntax on') | syntax reset | endif
let g:colors_name='minimal'

sil! hi! Normal NONE guifg=Gray guibg=Black

sil! hi! CursorLineNr  NONE
sil! hi! SignColumn    NONE
sil! hi! TabLine       NONE
sil! hi! TabLineFill   NONE
sil! hi! VertSplit     NONE

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

hi! Folded           NONE  cterm=italic
hi! MatchParen       NONE  cterm=bold ctermfg=LightYellow
hi! NonText          NONE  ctermfg=DarkGray
hi! QuickFixLine     NONE  cterm=underline
hi! TabLineSel       NONE  cterm=bold  ctermfg=White
hi! WarningMsg       NONE  ctermfg=Black  ctermbg=DarkYellow
hi! WildMenu         NONE  cterm=reverse
hi! debugPC          NONE  ctermbg=17

hi! link FoldColumn  NonText
hi! link LineNr      NonText
hi! link Whitespace  SpecialKey
