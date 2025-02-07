let g:ale_disable_lsp = 1
let g:ale_echo_msg_format = '[%linter%]: %s'
let g:ale_set_signs = 0
let g:ale_use_neovim_diagnostics_api = 0
let g:ale_virtualtext_cursor = 0
let g:lsp_ale_diagnostics_severity = 'information'

hi! ALEInfo NONE ctermfg=15 ctermbg=4
hi! link ALEError   Error
hi! link ALEWarning WarningMsg


" Vale {{{

" Supported filetypes taken from:
"   https://vale.sh/docs/topics/scoping/#code-1
" (and from format associations in .vale.ini file)

let s:vale_fts = #{
      \   arduino: '.cpp',
      \   c: '.c',
      \   cpp: '.cpp',
      \   cs: '.cs',
      \   css: '.css',
      \   gitcommit: '.txt',
      \   go: '.go',
      \   groovy: '.groovy',
      \   haskell: '.hs',
      \   help: '.txt',
      \   html: '.html',
      \   java: '.java',
      \   javascript: '.js',
      \   julia: '.jl',
      \   less: '.less',
      \   lua: '.lua',
      \   perl: '.pl',
      \   php: '.php',
      \   powershell: '.ps1',
      \   proto: '.proto',
      \   python: '.py',
      \   r: '.r',
      \   ruby: '.rb',
      \   rust: '.rs',
      \   sass: '.saas',
      \   scala: '.scala',
      \   swift: '.swift',
      \   typescript: '.ts',
      \ }

call map(s:vale_fts,
      \  {ft,ext ->
      \   ale#linter#Define(ft, {
      \     'name': 'vale',
      \     'executable': 'vale',
      \     'command': {->
      \        '%e'
      \        . (empty(expand('%:e')) ? (' --ext='.ext) : '')
      \        . ' --output=JSON %t'
      \     },
      \     'callback': 'ale#handlers#vale#Handle',
      \   })
      \  }
      \ )

unlet s:vale_fts

" }}}
