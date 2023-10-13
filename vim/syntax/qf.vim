if exists("b:current_syntax") | finish | endif

syn match qfFileName  ' \zs.*\ze:\d\+:\d\+  '
syn match qfError     '^\s*\zs\[E]\ze '
syn match qfWarn      '^\s*\zs\[W]\ze '
syn match qfLineNr    ':\d\+:\d\+'

hi! def link qfFileName  Directory
hi! def link qfLineNr  LineNr

hi! def link qfError Error
hi! def link qfWarn  WarningMsg

let b:current_syntax = "qf"
