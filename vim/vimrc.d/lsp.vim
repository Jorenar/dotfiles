let g:enable_lsp = 1

if g:enable_lsp

  let g:lsp_diagnostics_enabled = 0

  function! s:lsp_init() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> <Leader><Leader>r :w<CR><Plug>(lsp-rename)
  endfunction

  augroup LSP
    au!
    autocmd User lsp_buffer_enabled call s:lsp_init()

    if executable('ccls')
      au User lsp_setup call lsp#register_server({
            \ 'name': 'ccls',
            \ 'cmd': {server_info->['ccls']},
            \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
            \ 'initialization_options': {'cache': {'directory': '/tmp/ccls/cache' }, 'clang': {'extraArgs': ['--gcc-toolchain=/usr'] } },
            \ 'whitelist': [ 'c', 'cpp', 'objc', 'objcpp', 'cc' ],
            \ })
    endif

    if executable('pyls')
      au User lsp_setup call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': {server_info->['pyls']},
            \ 'whitelist': [ 'python' ],
            \ })
    endif

    if executable('java') && filereadable(expand($XDG_LSP_DIR.'/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'))
      au User lsp_setup call lsp#register_server({
            \ 'name': 'eclipse.jdt.ls',
            \ 'cmd': {server_info->[
            \     'java',
            \     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            \     '-Dosgi.bundles.defaultStartLevel=4',
            \     '-Declipse.product=org.eclipse.jdt.ls.core.product',
            \     '-Dlog.level=ALL',
            \     '-noverify',
            \     '-Dfile.encoding=UTF-8',
            \     '-Xmx1G',
            \     '-jar',
            \     expand($XDG_LSP_DIR.'/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'),
            \     '-configuration',
            \     expand($XDG_LSP_DIR.'/eclipse.jdt.ls/config_linux'),
            \     '-data',
            \     getcwd()
            \ ]},
            \ 'whitelist': [ 'java' ],
            \ })
    endif

    if executable('sqls')
      autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'sqls',
            \ 'cmd': {server_info->['sqls']},
            \ 'workspace_config': {
            \   'sqls': {
            \     'connections': [
            \       {
            \         'driver': 'mysql',
            \         'proto':  'unix',
            \         'user':   expand($SQLS_MYSQL_USER),
            \         'passwd': expand($SQLS_MYSQL_PASSWD),
            \         'path':   '/run/mysqld/mysqld.sock',
            \         'dbName': expand($SQLS_MYSQL_DB),
            \       },
            \     ],
            \   },
            \ },
            \ 'whitelist': [ 'sql' ]
            \ })
    endif

  augroup END

else
  MinPlug artur-shaik/vim-javacomplete2
  MinPlug davidhalter/jedi-vim
  MinPlug FromtonRouge/OmniCppComplete
  MinPlug vim-scripts/dbext.vim
endif

" vim: fdl=2
