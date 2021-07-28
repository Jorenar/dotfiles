" Servers {{{1
let s:servers = {}

let s:servers["ccls"] = #{
      \   cmd: "ccls",
      \   init: #{
      \     root: #{
      \       lsc: {m, p -> lsc#uri#documentUri(fnamemodify(findfile("compile_commands.json", expand("%:p") . ";"), ":p:h"))},
      \       lsp: {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), "compile_commands.json"))},
      \     },
      \     options: #{
      \       cache: #{ directory: "/tmp/ccls/cache" },
      \       clang: #{ extraArgs: ["--gcc-toolchain=/usr"] },
      \     },
      \   },
      \   ft: [ "c", "cpp", "objc", "objcpp", "cc" ],
      \ }

let s:servers["sqls"] = #{
      \   cmd: "sqls",
      \   workspace: #{
      \     sqls: #{
      \       connections: [
      \         #{
      \           driver: "sqlite3",
      \           dataSourceName: $SQLS_SQLITE_DB,
      \         },
      \         #{
      \           driver: "mysql",
      \           proto:  "unix",
      \           user:   empty($SQLS_MYSQL_USER) ? $USER : $SQLS_MYSQL_USER,
      \           passwd: $SQLS_MYSQL_PASSWD,
      \           path:   "/run/mysqld/mysqld.sock",
      \           dbName: $SQLS_MYSQL_DB,
      \         },
      \       ],
      \     },
      \   },
      \   ft: [ "sql" ]
      \ }

let s:servers["Eclipse JDT Language Server"] = #{
      \   cmd: "jdtls",
      \   ft: [ "java" ],
      \ }

let s:servers["Python Language Server"] = #{
      \   cmd: "pyls",
      \   ft: [ "python" ],
      \ }

let s:servers["TexLab"] = #{
      \   cmd: "texlab",
      \   ft: [ "tex" ],
      \ }

" helpers {{{1

function! s:register() abort
  for [ name, serv ] in items(s:servers)
    if executable(serv.cmd)
      call s:reg(name, serv)
    endif
  endfor
endfunction

" Clients {{{1
" vim-lsp {{{2

let g:lsp_diagnostics_enabled                = 1
let g:lsp_diagnostics_echo_cursor            = g:lsp_diagnostics_enabled
let g:lsp_diagnostics_highlights_delay       = 0
let g:lsp_diagnostics_signs_enabled          = 0
let g:lsp_document_code_action_signs_enabled = 0

hi! link LspErrorHighlight   Error
hi! link LspWarningHighlight WarningMsg

function! s:lsp_init() abort
  setlocal omnifunc=lsp#complete
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gR <Plug>(lsp-rename)
  nmap <buffer> gK <plug>(lsp-hover)
endfunction

function! s:lsp_register() abort
  function! s:reg(name, svr) abort
    let server = {}
    let server.name = a:name
    let server.cmd = { server_info -> [ a:svr.cmd ] }

    if has_key(a:svr, "init")
      if has_key(a:svr.init, "root")
        let server.root_uri = a:svr.init.root.lsp
      endif
      if has_key(a:svr.init, "options")
        let server.initialization_options = a:svr.init.options
      endif
    endif

    if has_key(a:svr, "workspace")
      let server.workspace_config = a:svr.workspace
    endif

    let server.whitelist = a:svr.ft

    call lsp#register_server(server)
  endfunction

  call s:register()
endfunction

augroup LSP
  autocmd!
  autocmd User lsp_buffer_enabled call s:lsp_init()
  autocmd User lsp_setup call s:lsp_register()
augroup END

" vim-lsc {{{2

let g:lsc_enable_autocomplete  = v:false

let g:lsc_auto_map = { "defaults": v:true,
      \   "Completion": "omnifunc",
      \   "ShowHover": "gK",
      \   "NextReference": "<Leader><C-n>",
      \   "PreviousReference": "<Leader><C-p>",
      \ }

hi! link lscDiagnosticWarning  WarningMsg

function! s:lsc_register() abort
  function! s:reg(name, svr) abort
    let server = {}
    let server.command = a:svr.cmd

    if has_key(a:svr, "init")
      let server.message_hooks = {}
      let server.message_hooks.initialize = {}

      if has_key(a:svr.init, "root")
        let server.message_hooks.initialize.rootUri = a:svr.init.root.lsc
      endif

      if has_key(a:svr.init, "options")
        let server.message_hooks.initialize.initializationOptions = a:svr.init.options
      endif
    endif

    if has_key(a:svr, "workspace")
      let server.workspace_config = a:svr.workspace
    endif

    let server.suppress_stderr = v:true

    for ft in a:svr.ft
      let g:lsc_server_commands[ft] = server
    endfor
  endfunction

  let g:lsc_server_commands = {}
  call s:register()
endfunction

call s:lsc_register()

function! s:lsc_init() abort
  if !get(g:, "loaded_lsc", 0) | return | endif

  nnoremap <buffer> <F2> :LSClientAllDiagnostics<CR>

  autocmd VimEnter <buffer>
        \  if empty(filter(getqflist(), "v:val.valid"))
        \|   exec "LSClientAllDiagnostics" | q
        \| endif

  " autocmd VimLeavePre <buffer> call lsc#server#disable() | delfunction lsc#server#exit

endfunction

augroup LSC_
  autocmd!
  exec "autocmd FileType " . join(keys(g:lsc_server_commands), ",") . " call s:lsc_init()"
augroup END
