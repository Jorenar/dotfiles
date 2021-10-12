let s:servers = {
      \   "ccls": #{
      \     command: "ccls",
      \     message_hooks: #{
      \       initialize: #{
      \         rootUri: {m, p -> lsc#uri#documentUri(fnamemodify(findfile("compile_commands.json", expand("%:p") . ";"), ":p:h"))},
      \         initializationOptions: #{
      \           cache: #{ directory: "/tmp/ccls/cache" },
      \           clang: #{ extraArgs: ["--gcc-toolchain=/usr"] },
      \         },
      \       },
      \     },
      \     ft: [ "c", "cpp", "objc", "objcpp" ],
      \   },
      \   "sqls": #{
      \     command: "sqls",
      \     workspace_config: #{
      \       sqls: #{
      \         connections: [
      \           #{
      \             driver: "sqlite3",
      \             dataSourceName: $SQLS_SQLITE_DB,
      \           },
      \           #{
      \             driver: "mysql",
      \             proto:  "unix",
      \             user:   empty($SQLS_MYSQL_USER) ? $USER : $SQLS_MYSQL_USER,
      \             passwd: $SQLS_MYSQL_PASSWD,
      \             path:   "/run/mysqld/mysqld.sock",
      \             dbName: $SQLS_MYSQL_DB,
      \           },
      \         ],
      \       },
      \     },
      \     ft: [ "sql" ]
      \   },
      \   "Eclipse JDT Language Server": #{
      \     command: "jdtls",
      \     ft: [ "java" ],
      \   },
      \   "Python Language Server": #{
      \     command: "pyls",
      \     ft: [ "python" ],
      \   },
      \   "TexLab": #{
      \     command: "texlab",
      \     ft: [ "tex" ],
      \   },
      \   "Deno": #{
      \     command: "deno lsp",
      \     message_hooks: #{
      \       initialize: #{
      \         initializationOptions: #{
      \           enable: v:true,
      \           unstable: v:true,
      \           lint: v:true,
      \           codeLens: #{
      \             implementations: v:true,
      \             references: v:true,
      \             referencesAllFunctions: v:true,
      \             test: v:true,
      \           },
      \           suggest: #{
      \             names: v:true,
      \           },
      \         },
      \       },
      \     },
      \     ft: [ "javascript", "typescript" ],
      \   }
      \ }

let g:lsc_server_commands = {}
for [ s:name, s:serv ] in items(s:servers)
  if executable(split(s:serv.command)[0])
    let server = s:serv
    let server.name = s:name
    let server.suppress_stderr = v:true
    for ft in remove(server, "ft")
      let g:lsc_server_commands[ft] = server
    endfor
  endif
endfor | unlet s:name s:serv s:servers
