" vim: fdl=1

" handlers {{{
" {{{1

function! s:on_lsp_server_init() abort
  let l:servers = lsp#get_allowed_servers()

  if index(l:servers, 'ccls') >= 0 || index(l:servers, 'clangd') >= 0
    call s:ccls_clangd_combo()
  endif
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

augroup LSP_SERVERS
  autocmd!
  autocmd User lsp_setup call s:on_lsp_setup()
  autocmd User lsp_server_init call s:on_lsp_server_init()
augroup END

" }}}

let g:langservs = {
      \   'asm-lsp'      : executable('asm-lsp'),
      \   'ccls'         : executable('ccls'),
      \   'clangd'       : executable('clangd'),
      \   'deno'         : executable('deno'),
      \   'digestif'     : executable('digestif'),
      \   'jdtls'        : executable('jdtls'),
      \   'gopls'        : executable('gopls'),
      \   'groovyls'     : executable('java') && filereadable($XDG_DATA_HOME.'/java/groovy-language-server-all.jar'),
      \   'jedi'         : executable('jedi-language-server'),
      \   'openscad-lsp' : executable('openscad-lsp'),
      \   'sonarlint'    : executable('sonarlint-ls'),
      \   'sqls'         : executable('sqls'),
      \   'texlab'       : executable('texlab'),
      \   'vim-ls'       : executable('vim-language-server'),
      \ }

function! s:on_lsp_setup() abort

  if g:langservs['asm-lsp']
    call lsp#register_server(#{
          \   name: 'asm-lsp',
          \   cmd: [ 'asm-lsp' ],
          \   root_uri: {-> lsp#utils#path_to_uri(
          \     lsp#utils#find_nearest_parent_file_directory(
          \       lsp#utils#get_buffer_path(),
          \       [ '.git/' ]
          \     )
          \   )},
          \   allowlist: [ 'asm', 'nasm' ],
          \ })
  endif

  if g:langservs['ccls']
    call lsp#register_server(#{
          \   name: 'ccls',
          \   cmd: [ 'ccls' ],
          \   root_uri: {-> lsp#utils#path_to_uri(
          \     lsp#utils#find_nearest_parent_file_directory(
          \       lsp#utils#get_buffer_path(),
          \       [ 'compile_commands.json', '.ccls', '.git/' ]
          \     )
          \   )},
          \   initialization_options: #{
          \     cache: #{ directory: $XDG_CACHE_HOME.'/ccls-cache' },
          \     clang: #{ extraArgs: [ '--gcc-toolchain=/usr' ] },
          \   },
          \   allowlist: [ 'c', 'cpp', 'objc', 'objcpp' ],
          \ })
  endif

  if g:langservs['clangd']
    call lsp#register_server(#{
          \   name: 'clangd',
          \   cmd: ['clangd',
          \     '--header-insertion-decorators=false',
          \     '--background-index',
          \   ],
          \   root_uri: {-> lsp#utils#path_to_uri(
          \     lsp#utils#find_nearest_parent_file_directory(
          \       lsp#utils#get_buffer_path(),
          \       [ 'compile_commands.json', '.clangd', '.git/' ]
          \     )
          \   )},
          \   allowlist: [ 'c', 'cpp', 'objc', 'objcpp' ],
          \ })
  endif

  if g:langservs['deno']
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

  if g:langservs['digestif']
    call lsp#register_server(#{
          \   name: 'Digestif',
          \   cmd: [ 'digestif' ],
          \   allowlist: [ 'tex' ],
          \ })
  endif

  if g:langservs['gopls']
    call lsp#register_server(#{
          \   name: 'gopls',
          \   cmd: [ 'gopls' ],
          \   allowlist: [ 'go' ],
          \ })
  endif

  if g:langservs['groovyls']
    call lsp#register_server(#{
          \   name: 'Groovy Language Server',
          \   cmd: [
          \     'java', '-jar',
          \     $XDG_DATA_HOME.'/java/groovy-language-server-all.jar'
          \   ],
          \   root_uri: {-> lsp#utils#path_to_uri(
          \     lsp#utils#find_nearest_parent_file_directory(
          \       lsp#utils#get_buffer_path(),
          \       [ 'Jenkinsfile', '.git/' ]
          \     )
          \   )},
          \   allowlist: [ 'groovy' ],
          \ })
  endif

  if g:langservs['jdtls']
    call lsp#register_server(#{
          \   name: 'Eclipse JDT Language Server',
          \   cmd: [ 'jdtls' ],
          \   allowlist: [ 'java' ],
          \ })
  endif

  if g:langservs['jedi']
    call lsp#register_server(#{
          \   name: 'Jedi',
          \   cmd: [ 'jedi-language-server' ],
          \   allowlist: [ 'python' ],
          \ })
  endif

  if g:langservs['openscad-lsp']
    call lsp#register_server(#{
          \   name: 'openscad-LSP',
          \   cmd: [ 'openscad-lsp', '--stdio' ],
          \   allowlist: [ 'openscad' ],
          \ })
  endif

  if g:langservs['sonarlint']
    let g:lsp_use_native_client = 0

    call lsp#register_server(#{
          \   name: 'SonarLint',
          \   cmd: [
          \     'sonarlint-ls', '-stdio',
          \   ] + [ '-analyzers' ]
          \     + split(glob('/usr/share/java/sonarlint-ls/analyzers/*')),
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
          \   allowlist: [ 'c', 'cpp', 'go', 'javascript', 'php', 'python' ],
          \ })

    call lsp#callbag#pipe(
          \   lsp#stream(),
          \   lsp#callbag#filter({x ->
          \     x->get('request', x->get('response', {}))->get('method', '') =~# 'sonarlint/'
          \   }),
          \   lsp#callbag#subscribe({ 'next':{x->s:sonarlint_handler(x)} }),
          \ )
  endif

  if g:langservs['sqls']
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

  if g:langservs['texlab']
    call lsp#register_server(#{
          \   name: 'TexLab',
          \   cmd: [ 'texlab' ],
          \   allowlist: [ 'tex' ],
          \ })
  endif

  if g:langservs['vim-ls']
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

endfunction
