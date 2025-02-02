-- vim: fdl=1

vim.g.lsp_loaded = true  -- disable vim-lsp

-- helpers {{{
-- {{{1
local function isEnabled(client)
  local name = (client.name and client.name or client)
  local val = vim.g.langservs[name]
  return not (val == 0 or val == false or val == nil)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    focusable = false,
    border = "single"
  })

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, d, c, _)
  local bufnr = vim.api.nvim_get_current_buf()
  local client = vim.lsp.get_client_by_id(c.client_id)

  local messages = {}
  for _, event in ipairs(d.diagnostics) do
    local msg = {}
    msg.text = "[" .. client.name .. "]: " .. event.message
    msg.lnum = event.range.start.line+1
    msg.end_lnum = event.range["end"].line+1
    msg.col = event.range.start.character+1
    msg.end_col = event.range["end"].character+1
    msg.bufnr = bufnr
    msg.nr = event.severity
    table.insert(messages, msg)
  end

  vim.fn['ale#other_source#ShowResults'](bufnr, "nvim-lsp:" .. client.id, messages)
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      client.server_capabilities.semanticTokensProvider = nil

      vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
      if vim.o.tagfunc == 'v:lua.vim.lsp.tagfunc' then
        vim.o.tagfunc = ''
      end

      vim.keymap.set('n', 'L', "<Cmd>exec {l -> empty(l) ? '' : 'norm L'.l}(input('L'))<CR>", { buffer = true })

      vim.keymap.set('n', 'LK', vim.lsp.buf.hover, { buffer = true })
      vim.keymap.set('n', 'LR', vim.lsp.buf.rename, { buffer = true })

      vim.keymap.set('n', 'Lca', vim.lsp.buf.code_action, { buffer = true })

      vim.keymap.set('n', 'Lgg', vim.lsp.buf.definition, { buffer = true })
      vim.keymap.set('n', 'Lgd', vim.lsp.buf.declaration, { buffer = true })
      vim.keymap.set('n', 'Lgi', vim.lsp.buf.implementation, { buffer = true })
      vim.keymap.set('n', 'Lgt', vim.lsp.buf.type_definition, { buffer = true })

      vim.keymap.set('n', 'Lfr', vim.lsp.buf.references, { buffer = true })
      vim.keymap.set('n', 'Lfs', vim.lsp.buf.workspace_symbol, { buffer = true })
      vim.keymap.set('n', 'Lfi', vim.lsp.buf.incoming_calls, { buffer = true })
      vim.keymap.set('n', 'Lfo', vim.lsp.buf.outgoing_calls, { buffer = true })
    end
  })

local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("warning: multiple different client offset_encodings") then
    return
  end
  notify(msg, ...)
end
-- }}}

local function myServers()
  local LSPCONFIG = require('lspconfig')

  local function setup(name, conf)
    if isEnabled(name) then
      LSPCONFIG[name].setup(conf and conf or {})
    end
  end

  setup('jdtls', {})
  setup('asm_lsp', {})
  setup('digestif', {})
  setup('gopls', {})
  setup('jedi_language_server', {})
  setup('openscad_lsp', {})
  setup('texlab', {})
  setup('vimls', {})

  setup('ccls', {
      initialization_options = {
        cache = { directory = vim.env.XDG_CACHE_HOME .. '/ccls-cache' },
        clang = { extraArgs = { '--gcc-toolchain=/usr' } },
      },
      on_attach = function(client, _)
        if not isEnabled('clangd') then return end
        client.server_capabilities = {
          completionProvider = client.server_capabilities.completionProvider,
          textDocumentSync = client.server_capabilities.textDocumentSync,
        }
      end
    })

  setup('clangd', {
      cmd = { "clangd",
        "--header-insertion-decorators=false",
        "--background-index",
      },
      on_attach = function(client, _)
        if not isEnabled('ccls') then return end
        client.server_capabilities.completionProvider = nil
      end
    })

  setup('denols', {
      settings = {
        deno = {
          config = vim.env.XDG_CONFIG_HOME .. "/deno.json",
          enable = true,
          unstable = true,
          lint = true,
          codeLens = {
            implementations = true,
            references = true,
            referencesAllFunctions = true,
            test = true,
          },
          suggest = {
            names = true,
            imports = {
              hosts = {
                ["https://deno.land"] = true
              }
            }
          }
        }
      }
    })

  setup('sqls', {
      cmd = {"sqls", "-config", ".sqls.yml"},
      on_attach = function(client, bufnr)
        require('sqls').on_attach(client, bufnr)
      end
    })

  vim.cmd [[ LspStart ]]
end

vim.api.nvim_create_autocmd("VimEnter", { callback = myServers })
