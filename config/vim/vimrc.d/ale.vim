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

" Semgrep {{{

" Supported filetypes taken from:
"   https://semgrep.dev/docs/supported-languages

let s:semgrep_fts = [
      \   'apex',
      \   'bash',
      \   'c',
      \   'clojure',
      \   'cpp',
      \   'cs',
      \   'dart',
      \   'dockerfile',
      \   'elixir',
      \   'go',
      \   'html',
      \   'java',
      \   'javascript',
      \   'json',
      \   'julia',
      \   'kotlin',
      \   'lisp',
      \   'lua',
      \   'ocaml',
      \   'php',
      \   'python',
      \   'r',
      \   'ruby',
      \   'rust',
      \   'scala',
      \   'scheme',
      \   'solidity',
      \   'swift',
      \   'terraform',
      \   'typescript',
      \   'xml',
      \   'yaml',
      \ ]

function! s:semgrep_handler(buffer, lines) abort
    let l:pattern = '\v^[^:]+:(\d+):(\d+):([EWIH]):[^:]+:(.+)$'
    return map(ale#util#GetMatches(a:lines, l:pattern), {_, match -> {
          \   'lnum': match[1] + 0,
          \   'col': match[2] + 0,
          \   'text': match[4],
          \   'type': match[3],
          \ }})
endfunction

call map(s:semgrep_fts, {_,ft ->
      \   ale#linter#Define(ft, {
      \     'name': 'semgrep',
      \     'executable': 'semgrep',
      \     'command': '%e' . ' scan --vim --config '.$XDG_CONFIG_HOME .'/semgrep/settings.yaml -',
      \     'callback': function('s:semgrep_handler'),
      \   })
      \ })

unlet s:semgrep_fts

" }}}
