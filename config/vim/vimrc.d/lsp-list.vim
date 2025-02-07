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
      \   'sonarlint'    : executable('java') && isdirectory($XDG_DATA_HOME.'/java/sonarlint-ls'),
      \   'sqls'         : executable('sqls'),
      \   'texlab'       : executable('texlab'),
      \   'vimls'        : executable('vim-language-server'),
      \ }
