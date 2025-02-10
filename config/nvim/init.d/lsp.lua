local LSPCONFIG = require('lspconfig')
local GP = require('goto-preview')

-- vim.lsp.set_log_level("debug")

-- helpers {{{1

local function isServEnabled(client)
  local name = (client.name and client.name or client)
  local val = vim.g.langservs[name]
  return not (val == 0 or val == false or val == nil)
end

local function setup(name, conf)
  vim.api.nvim_create_autocmd("BufReadPre", {
      once = true,
      callback = function()
        if not (isServEnabled(name) or isServEnabled(name:gsub('_', '-'))) then
          return
        end

        if name == 'sonarlint' then
          require('sonarlint').setup(conf)
          return
        end

        if name == 'jedi' then
          name = 'jedi_language_server'
        end

        LSPCONFIG[name].setup(conf and conf or {})
      end
    })
end

-- keymaps {{{1

local keymaps = {
  { 'n', 'L', "<Cmd>exec {l -> empty(l) ? '' : 'norm L'.l}(input('L'))<CR>" },

  { 'n', 'LK',  vim.lsp.buf.hover },
  { 'n', 'LR',  vim.lsp.buf.rename },

  { 'n', 'Lca', vim.lsp.buf.code_action },

  { 'n', 'Lgg', vim.lsp.buf.definition },
  { 'n', 'Lgd', vim.lsp.buf.declaration },
  { 'n', 'Lgi', vim.lsp.buf.implementation },
  { 'n', 'Lgt', vim.lsp.buf.type_definition },

  { 'n', 'Lkg', GP.goto_preview_definition },
  { 'n', 'Lkd', GP.goto_preview_declaration },
  { 'n', 'Lki', GP.goto_preview_implementation },
  { 'n', 'Lkt', GP.goto_preview_type_definition },

  { 'n', 'Lfr', vim.lsp.buf.references },
  { 'n', 'Lfs', vim.lsp.buf.workspace_symbol },
  { 'n', 'Lfi', vim.lsp.buf.incoming_calls },
  { 'n', 'Lfo', vim.lsp.buf.outgoing_calls },
}

-- servers {{{1

setup('asm_lsp', {})
setup('digestif', {})
setup('gopls', {})
setup('jdtls', {})
setup('jedi', {})
setup('openscad_lsp', {})
setup('texlab', {})
setup('vimls', {})

setup('ccls', {
    init_options = {
      cache = { directory = '.cache/ccls' },
      clang = { extraArgs = { '--gcc-toolchain=/usr' } },
    },
    on_attach = function(client, _)
      if not isServEnabled('clangd') then return end
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
      if not isServEnabled('ccls') then return end
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

setup('sonarlint', {
    server = {
      cmd = (function(dir) return {
        'java',
        '-Duser.home=' .. vim.env.XDG_CACHE_HOME,
        '-jar', dir .. '/sonarlint-ls.jar',
        '-stdio',
        '-analyzers=',
        unpack(vim.fn.glob(dir .. '/analyzers/*.jar', 1, 1)),
      } end)(vim.env.XDG_DATA_HOME .. '/java/sonarlint-ls'),
    },
    settings = {
      sonarlint = {
        disableTelemetry = true,
      },
    },
    filetypes = {
      'c',
      'cpp',
      'css',
      'dockerfile',
      'go',
      'html',
      'java',
      'javascript',
      'php',
      'python',
      'xml',
    }
  })

-- handlers {{{1

GP.setup {
  focus_on_open = false,
  dismiss_on_move = true,
  preview_window_title = { enable = false },
}

vim.api.nvim_create_autocmd("VimEnter", { callback = function()
  vim.cmd [[ LspStart ]]
end })

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    focusable = false,
    border = "single"
  })

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, d, c, _)
  -- diagnostics in ALE
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

      if client.server_capabilities['completionProvider'] ~= nil then
        vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
      end

      if vim.o.tagfunc == 'v:lua.vim.lsp.tagfunc' then
        vim.o.tagfunc = ''
      end

      local K = vim.fn.maparg('K', 'n', false, true)
      if K.buffer == 1 and K.desc == "vim.lsp.buf.hover()" then
        vim.api.nvim_buf_del_keymap(args.buf, 'n', 'K')
      end

      for _,k in ipairs(keymaps) do
        vim.keymap.set(k[1], k[2], k[3], { buffer = true, noremap = true })
      end
    end
  })

local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("warning: multiple different client offset_encodings") then
    return
  end
  notify(msg, ...)
end
