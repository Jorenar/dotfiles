if &rtp !~# 'vim-lsp' | finish | endif

let g:lsp_ale_auto_config_ale = 0
let g:lsp_ale_auto_config_vim_lsp = 0

let g:lsp_diagnostics_highlights_delay       = 0
let g:lsp_diagnostics_highlights_enabled     = 1
let g:lsp_diagnostics_signs_enabled          = 0
let g:lsp_diagnostics_virtual_text_enabled   = 0
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_show_message_log_level             = 'info'
let g:lsp_text_edit_enabled                  = 0
let g:lsp_use_native_client                  = 1

let g:lsp_log_verbose = 0
let g:lsp_log_file = $XDG_STATE_HOME . "/vim/lsp.log"

hi! link LspErrorHighlight   Error
hi! link LspWarningHighlight WarningMsg

let s:keymaps = { 0:[
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
      \ ]}

function! s:on_lsp_setup() abort

  if s:isServEnabled('asm-lsp')
    call lsp#register_server(#{
          \   name: 'asm-lsp',
          \   cmd: [ 'asm-lsp' ],
          \   root_uri: {-> s:find_root_uri([ '.git/' ])},
          \   allowlist: [ 'asm', 'nasm' ],
          \ })
  endif

  if s:isServEnabled('ccls')
    call lsp#register_server(#{
          \   name: 'ccls',
          \   cmd: [ 'ccls' ],
          \   root_uri: {-> s:find_root_uri([ 'compile_commands.json', '.ccls', '.git/' ])},
          \   initialization_options: #{
          \     cache: #{ directory: '.cache/ccls' },
          \     clang: #{ extraArgs: [ '--gcc-toolchain=/usr' ] },
          \   },
          \   allowlist: [ 'c', 'cpp', 'objc', 'objcpp' ],
          \ })
  endif

  if s:isServEnabled('clangd')
    call lsp#register_server(#{
          \   name: 'clangd',
          \   cmd: ['clangd',
          \     '--header-insertion-decorators=false',
          \     '--background-index',
          \   ],
          \   root_uri: {-> s:find_root_uri([ 'compile_commands.json', '.clangd', '.git/' ])},
          \   allowlist: [ 'c', 'cpp', 'objc', 'objcpp' ],
          \ })
  endif

  if s:isServEnabled('denols')
    call lsp#register_server(#{
          \   name: 'Deno',
          \   cmd: [ 'deno', 'lsp' ],
          \   initialization_options: #{
          \     config: $XDG_CONFIG_HOME . '/deno.json',
          \     enable: v:true,
          \     unstable: v:true,
          \     lint: v:true,
          \     codeLens: #{
          \       implementations: v:true,
          \       references: v:true,
          \       referencesAllFunctions: v:true,
          \       test: v:true,
          \     },
          \     suggest: #{
          \       names: v:true,
          \     },
          \   },
          \   allowlist: [ 'javascript', 'typescript' ],
          \ })
  endif

  if s:isServEnabled('digestif')
    call lsp#register_server(#{
          \   name: 'Digestif',
          \   cmd: [ 'digestif' ],
          \   allowlist: [ 'tex' ],
          \ })
  endif

  if s:isServEnabled('gopls')
    call lsp#register_server(#{
          \   name: 'gopls',
          \   cmd: [ 'gopls' ],
          \   allowlist: [ 'go' ],
          \ })
  endif

  if s:isServEnabled('groovyls')
    call lsp#register_server(#{
          \   name: 'Groovy Language Server',
          \   cmd: [
          \     'java', '-jar',
          \     $XDG_DATA_HOME.'/java/groovy-language-server-all.jar'
          \   ],
          \   root_uri: {-> s:find_root_uri([ 'Jenkinsfile', '.git/' ])},
          \   allowlist: [ 'groovy' ],
          \ })
  endif

  if s:isServEnabled('jdtls')
    call lsp#register_server(#{
          \   name: 'Eclipse JDT Language Server',
          \   cmd: [ 'jdtls' ],
          \   allowlist: [ 'java' ],
          \ })
  endif

  if s:isServEnabled('jedi')
    call lsp#register_server(#{
          \   name: 'Jedi',
          \   cmd: [ 'jedi-language-server' ],
          \   allowlist: [ 'python' ],
          \ })
  endif

  if s:isServEnabled('openscad-lsp')
    call lsp#register_server(#{
          \   name: 'openscad-LSP',
          \   cmd: [ 'openscad-lsp', '--stdio' ],
          \   allowlist: [ 'openscad' ],
          \ })
  endif

  if s:isServEnabled('sqls')
    call lsp#register_server(#{
          \   name: 'sqls',
          \   cmd: {->
          \     [ 'sqls' ]
          \     + { yml ->
          \          empty(yml) ? [] : [ '-config', yml ]
          \       }(lsp#utils#find_nearest_parent_file(
          \           lsp#utils#get_buffer_path(), '.sqls.yml'
          \        ))
          \   },
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
          \   allowlist: [ 'sql' ]
          \ })

    call lsp#callbag#pipe(
          \   lsp#stream(),
          \   lsp#callbag#filter({x ->
          \     x->get('request', {})->get('params', {})->get('command', '') =~# '\v(executeQuery|show)'
          \   }),
          \   lsp#callbag#subscribe({ 'next':{x->s:sqls_handler(x)} }),
          \ )
  endif

  if s:isServEnabled('texlab')
    call lsp#register_server(#{
          \   name: 'TexLab',
          \   cmd: [ 'texlab' ],
          \   allowlist: [ 'tex' ],
          \ })
  endif

  if s:isServEnabled('vimls')
    call lsp#register_server(#{
          \   name: 'VimScript Language Server',
          \   cmd: [ 'vim-language-server', '--stdio' ],
          \   initialization_options: #{
          \     vimruntime: $VIMRUNTIME,
          \     runtimepath: &rtp,
          \   },
          \   allowlist: [ 'vim' ],
          \ })
  endif

  if s:isServEnabled('sonarlint') && v:false
    let g:lsp_use_native_client = 0

    call lsp#register_server(#{
          \   name: 'SonarLint',
          \   cmd: {dir -> [
          \         'java',
          \         '-Duser.home=' . $XDG_CACHE_HOME,
          \         '-jar', dir . '/sonarlint-ls.jar',
          \         '-stdio',
          \         '-analyzers'
          \       ] + glob(dir . '/analyzers/*', 1, 1)
          \     }($XDG_DATA_HOME . '/java/sonarlint-ls'),
          \   root_uri: {-> lsp#utils#path_to_uri('.')},
          \   initialization_options: #{
          \     productKey: 'vim-lsp',
          \   },
          \   workspace_config: [
          \     #{
          \       disableTelemetry: v:true,
          \       pathToCompileCommands:
          \         lsp#utils#find_nearest_parent_file(
          \           lsp#utils#get_buffer_path(),
          \           'compile_commands.json'
          \         ),
          \       rules: {},
          \     },
          \   ],
          \   allowlist: [ '*' ],
          \ })

    call lsp#callbag#pipe(
          \   lsp#stream(),
          \   lsp#callbag#filter({x ->
          \     x->get('request', x->get('response', {}))->get('method', '') =~# 'sonarlint/'
          \   }),
          \   lsp#callbag#subscribe({ 'next':{x->s:sonarlint_handler(x)} }),
          \ )
  endif

endfunction

" handlers and helpers {{{

function! s:lsp_init() abort
  setlocal omnifunc=lsp#complete

  for k in s:keymaps[0]
    exec k[0].'map' '<buffer>' k[1] k[2]
  endfor
endfunction

function! s:on_lsp_server_init() abort
  let l:servers = lsp#get_allowed_servers()

  if index(l:servers, 'ccls') >= 0 || index(l:servers, 'clangd') >= 0
    call s:ccls_clangd_combo()
  endif
endfunction

function! s:find_root_uri(markers) abort
  return lsp#utils#path_to_uri(
        \     lsp#utils#find_nearest_parent_file_directory(
        \       lsp#utils#get_buffer_path(),
        \       a:markers
        \     )
        \   )
endfunction

function! s:ccls_clangd_combo() abort
  let l:clangd = lsp#get_server_capabilities('clangd')
  let l:ccls = lsp#get_server_capabilities('ccls')

  if empty(l:ccls) || empty(l:clangd)
    return
  endif

  call extend(l:ccls, #{
        \   callHierarchyProvider: v:false,
        \   declarationProvider: v:false,
        \   definitionProvider: v:false,
        \   hoverProvider: v:false,
        \   implementationProvider: v:false,
        \   referencesProvider: v:false,
        \   typeDefinitionProvider: v:false,
        \ })
  call remove(l:clangd, 'completionProvider')
endfunction

function! s:sonarlint_handler(x) abort
  const l:type = has_key(a:x, 'request') ? 'request' : 'response'
  const l:method = substitute(a:x[l:type]['method'], '^sonarlint/', '', '')

  let l:res = {}

  if has_key(a:x[l:type], 'id')
    let l:res.id = a:x[l:type]['id']
  endif

  if l:type ==# 'request'
    let l:res.result = v:null
  endif

  if l:method ==# 'shouldAnalyseFile'
    let l:res.result = { 'shouldBeAnalysed': v:true }
  elseif l:method ==# 'isIgnoredByScm'
    let l:res.result = v:false
  elseif l:method ==# 'showRuleDescription'
    call lsp#ui#vim#output#preview(a:x['server'], prettyprint#prettyprint(a:x), {})
  endif

  if l:res != {}
    call lsp#send_request(a:x['server'], l:res)
  endif
endfunction

function! s:sqls_handler(x) abort
  let l:lines = a:x['response']['result']
  if empty(l:lines) | return | endif
  new | setlocal buftype=nofile
  call setline(1, split(l:lines, "\n"))
  " call lsp#ui#vim#output#preview(a:x['server'], l:lines, {})
endfunction

function! s:isServEnabled(client) abort
  let l:Val = get(g:enabled_lsp, a:client, 0)
  if type(l:Val) == v:t_dict && empty(l:Val)
    return executable(a:client)
  elseif type(l:Val) == v:t_func
    return l:Val()
  else
    return l:Val
  endif
endfunction

augroup LSP
  autocmd!
  autocmd User lsp_buffer_enabled call s:lsp_init()
  autocmd User lsp_setup call s:on_lsp_setup()
  autocmd User lsp_server_init call s:on_lsp_server_init()
augroup END

" }}}
