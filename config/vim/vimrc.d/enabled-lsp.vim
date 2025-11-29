function! EnabledLsp(client) abort
  let l:V = get(g:enabled_lsp, a:client, 0)
  let l:R = type(l:V) == v:t_func ? l:V() : l:V
  return l:R ? v:true : v:false  " for Lua
endfunction

let g:enabled_lsp = {
      \   'asm_lsp': {-> executable('asm-lsp')},
      \   'ast_grep': {-> executable('ast-grep')},
      \   'autotools_ls': {-> executable('autotools-language-server')},
      \   'bashls': {-> executable('bash-language-server')},
      \   'ccls': {-> executable('ccls') && !executable('clangd') },
      \   'clangd': {-> executable('clangd')},
      \   'codebook': {-> executable('codebook-lsp')},
      \   'copilot': {-> executable('copilot-language-server')},
      \   'cssls': {-> executable('vscode-css-language-server')},
      \   'denols': {-> executable('deno')},
      \   'digestif': {-> executable('digestif')},
      \   'gopls': {-> executable('gopls')},
      \   'gradle_ls': {-> executable('gradle-language-server')},
      \   'groovyls': {-> executable('groovy-language-server')},
      \   'harper_ls': {-> executable('harper-ls')},
      \   'jdtls': {-> executable('jdtls')},
      \   'jedi_language_server': {-> executable('jedi-language-server')},
      \   'jsonls': {-> executable('vscode-json-language-server') },
      \   'lua_ls': {-> executable('lua-language-server')},
      \   'm68k': {-> executable('m68k-lsp-server')},
      \   'openscad_lsp': {-> executable('openscad-lsp')},
      \   'sonarlint': {-> executable('sonarlint-language-server')},
      \   'sqls': {-> executable('sqls')},
      \   'texlab': {-> executable('taxlab')},
      \   'vimls': {-> executable('vim-language-server')},
      \   'yamlls': {-> executable('yaml-language-server')},
      \ }
