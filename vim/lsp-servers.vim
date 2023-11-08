if executable("ccls")
  au User lsp_setup call lsp#register_server(#{
        \   name: "ccls",
        \   cmd: [ "ccls" ],
        \   root_uri: {-> lsp#utils#path_to_uri(
        \     lsp#utils#find_nearest_parent_file_directory(
        \       lsp#utils#get_buffer_path(),
        \       [ "compile_commands.json", ".ccls", ".git/" ]
        \     )
        \   )},
        \   initialization_options: #{
        \     clang: #{ extraArgs: [ "--gcc-toolchain=/usr" ] },
        \   },
        \   allowlist: [ "c", "cpp", "objc", "objcpp" ],
        \ })
elseif executable('clangd')
  au User lsp_setup call lsp#register_server(#{
        \   name: "clangd",
        \   cmd: ["clangd",
        \     "--query-driver=/usr/bin/gcc",
        \     "--background-index",
        \     "--clang-tidy",
        \   ],
        \   allowlist: [ "c", "cpp", "objc", "objcpp" ],
        \ })
endif

if executable("jedi-language-server")
  au User lsp_setup call lsp#register_server(#{
        \   name: "Jedi",
        \   cmd: [ "jedi-language-server" ],
        \   allowlist: [ "python" ],
        \ })
endif

if executable("texlab")
  au User lsp_setup call lsp#register_server(#{
        \   name: "TexLab",
        \   cmd: [ "texlab" ],
        \   allowlist: [ "tex" ],
        \ })
endif

if executable("digestif")
  au User lsp_setup call lsp#register_server(#{
        \   name: "Digestif",
        \   cmd: [ "digestif" ],
        \   allowlist: [ "tex" ],
        \ })
endif

if executable("sqls")
  au User lsp_setup call lsp#register_server(#{
        \   name: "sqls",
        \   cmd: [ "sqls" ],
        \   workspace_config: #{
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
        \   allowlist: [ "sql" ]
        \ })
endif

if executable("jdtls")
  au User lsp_setup call lsp#register_server(#{
        \   name: "Eclipse JDT Language Server",
        \   cmd: [ "jdtls" ],
        \   allowlist: [ "java" ],
        \ })
endif

if executable("deno")
  au User lsp_setup call lsp#register_server(#{
        \   name: "Deno",
        \   cmd: [ "deno", "lsp" ],
        \   initialization_options: #{
        \     config: $XDG_CONFIG_HOME . "/deno.json",
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
        \   allowlist: [ "javascript", "typescript" ],
        \ })
endif

if executable("openscad-lsp")
  au User lsp_setup call lsp#register_server(#{
        \   name: "openscad-LSP",
        \   cmd: [ "openscad-lsp", "--stdio" ],
        \   allowlist: [ "openscad" ],
        \ })
endif
