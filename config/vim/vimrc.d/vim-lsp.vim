if &rtp !~# 'vim-lsp' | finish | endif

let g:lsp_ale_auto_config_ale = 0
let g:lsp_ale_auto_config_vim_lsp = 0

let g:lsp_settings_enable_suggestions = 0
let g:lsp_settings_servers_dir = $XDG_DATA_HOME . '/vim/lsp-servers'

let g:lsp_diagnostics_highlights_delay       = 0
let g:lsp_diagnostics_highlights_enabled     = 1
let g:lsp_diagnostics_signs_enabled          = 0
let g:lsp_diagnostics_virtual_text_enabled   = 0
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_text_edit_enabled                  = 0
let g:lsp_use_native_client                  = 1

let g:lsp_log_verbose = 0
let g:lsp_show_message_log_level = 'error'
let g:lsp_log_file = $XDG_STATE_HOME . "/vim/lsp.log"

hi! link LspErrorHighlight   ErrorMsg
hi! link LspWarningHighlight WarningMsg

let s:keymaps = [
      \   [ 'nnore', 'L', "<Cmd>exec {l -> empty(l) ? '' : 'norm L'.l}(input('L'))<CR>" ],
      \
      \   [ 'n', 'LK', '<Plug>(lsp-hover)' ],
      \   [ 'n', 'LR', '<Plug>(lsp-rename)' ],
      \
      \   [ 'n', 'Lca', '<plug>(lsp-code-action-float)' ],
      \
      \   [ 'n', 'Lgg', '<Plug>(lsp-definition)' ],
      \   [ 'n', 'Lgd', '<Plug>(lsp-declaration)' ],
      \   [ 'n', 'Lgi', '<Plug>(lsp-implementation)' ],
      \   [ 'n', 'Lgt', '<Plug>(lsp-type-definition)' ],
      \
      \   [ 'n', 'Lkg', '<Plug>(lsp-peek-definition)' ],
      \   [ 'n', 'Lkd', '<Plug>(lsp-peek-declaration)' ],
      \   [ 'n', 'Lki', '<Plug>(lsp-peek-implementation)' ],
      \   [ 'n', 'Lkt', '<Plug>(lsp-peek-type-definition)' ],
      \
      \   [ 'n', 'Lfr', '<Plug>(lsp-references)' ],
      \   [ 'n', 'Lfs', '<Plug>(lsp-workspace-symbol)<C-r><C-w><CR>' ],
      \   [ 'n', 'Lfi', '<Plug>(lsp-call-hierarchy-incoming)' ],
      \   [ 'n', 'Lfo', '<Plug>(lsp-call-hierarchy-outgoing)' ],
      \ ]

function! s:lsp_init() abort
  setlocal omnifunc=lsp#complete

  for k in s:keymaps
    exec k[0].'map' '<buffer>' k[1] k[2]
  endfor | unlet s:keymaps
endfunction

augroup LSP
  autocmd!
  autocmd User lsp_buffer_enabled call s:lsp_init()
augroup END


let g:lsp_settings = {}

let g:lsp_settings['clangd'] = #{
      \   args: [
      \     '--header-insertion-decorators=false',
      \     '--background-index',
      \   ],
      \ }

let g:lsp_settings['deno'] = #{
      \   workspace_config: {
      \     'deno': #{
      \       config: $XDG_CONFIG_HOME . '/deno.json',
      \       enable: v:true,
      \       unstable: v:true,
      \       lint: v:true,
      \       codeLens: #{
      \         implementations: v:true,
      \         references: v:true,
      \         referencesAllFunctions: v:true,
      \         test: v:true,
      \       },
      \       suggest: #{
      \         names: v:true,
      \         imports: #{
      \           hosts: {
      \             "https://deno.land": v:true
      \           }
      \         }
      \       },
      \     },
      \   },
      \ }

let g:lsp_settings['sqls'] = #{
      \   args: { yml -> empty(yml) ? [] : [ '-config', yml ] }(
      \     lsp#utils#find_nearest_parent_file(lsp#utils#get_buffer_path(), '.sqls.yml')
      \   ),
      \   workspace_config: #{
      \     sqls: #{
      \       connections: [
      \         #{
      \           driver: 'sqlite3',
      \           dataSourceName: $SQLS_SQLITE_DB,
      \         },
      \       ],
      \     },
      \   },
      \ }
