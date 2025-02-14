let g:enabled_lsp = {
      \   'asm-lsp'      : executable('asm-lsp'),
      \   'ccls'         : v:false,
      \   'clangd'       : executable('clangd'),
      \   'denols'       : executable('deno'),
      \   'digestif'     : executable('digestif'),
      \   'gopls'        : executable('gopls'),
      \   'groovyls'     : executable('java') && filereadable($XDG_DATA_HOME.'/java/groovy-language-server-all.jar'),
      \   'jdtls'        : executable('jdtls'),
      \   'jedi'         : executable('jedi-language-server'),
      \   'openscad-lsp' : executable('openscad-lsp'),
      \   'sonarlint'    : executable('java') && filereadable($XDG_DATA_HOME.'/java/sonarlint-ls/sonarlint-ls.jar'),
      \   'sqls'         : executable('sqls'),
      \   'texlab'       : executable('texlab'),
      \   'vimls'        : executable('vim-language-server'),
      \ }
