local LSPCONFIG = require('lspconfig')
local GP = require('goto-preview')

-- vim.lsp.set_log_level("debug")

-- helpers {{{1

local function isServEnabled(client)
  local function check(name)
    local val = vim.g.langservs[name]
    return not (val == 0 or val == false or val == nil)
  end
  local name = (client.name and client.name or client)
  return check(name) or check(name:gsub('-', '_'))
end

local function setup(name, conf)
  vim.api.nvim_create_autocmd({"BufReadPre", "FileType", "VimEnter"}, {
      once = true,
      callback = function(e)
        vim.api.nvim_del_autocmd(e.id)

        if not isServEnabled(name) then return end

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
    root_dir = function(fname)
      return vim.fs.root(fname, {
          'compile_commands.json', '.ccls', '.git'
        }) or '/tmp'
    end,
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
        '-analyzers',
        unpack(vim.fn.glob(dir .. '/analyzers/*.jar', 1, 1)),
      } end)(vim.env.XDG_DATA_HOME .. '/java/sonarlint-ls'),
      settings = {
        sonarlint = {
          disableTelemetry = true,
          pathToCompileCommands = (function()
            local loc = vim.fs.find("compile_commands.json", {
                path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
                upward = true,
              })
            return #loc > 0 and loc[1] or nil
          end)(),
        },
      },
      on_attach = function(_,_)
        if vim.fn.exists(':SonarlintListRules') ~= 0 then
          vim.api.nvim_del_user_command('SonarlintListRules')
        end
      end,
    },
    filetypes = { '*' }
  })

-- handlers {{{1

GP.setup {
  focus_on_open = false,
  dismiss_on_move = true,
  preview_window_title = { enable = false },
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    focusable = false,
    border = "single"
  })

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, d, c, _)
  -- diagnostics in ALE
  vim.fn['ale#other_source#ShowResults'](
    vim.api.nvim_get_current_buf(),
    "nvim-lsp:" .. c.client_id,
    vim.tbl_map(function(e)
      return {
        text     = "[" .. e.source .. "]: " .. e.message,
        detail   = vim.inspect(e),
        lnum     = e.range["start"].line + 1,
        end_lnum = e.range["end"].line + 1,
        col      = e.range["start"].character + 1,
        end_col  = e.range["end"].character + 1,
        type = ({
            [vim.diagnostic.severity.ERROR] = 'E',
            [vim.diagnostic.severity.WARN]  = 'W',
            [vim.diagnostic.severity.INFO]  = 'I',
            [vim.diagnostic.severity.HINT]  = 'I',
          })[e.severity]
    } end, d.diagnostics)
  )
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

vim.notify = (function(vim_notify)
  local ignored = {
    "warning: multiple different client offset_encodings",
    "SonarQube language server is ready.",
    "Couldn't find compile_commands.json. Make sure it exists in a parent directory.",
  }
  return function(msg, ...)
    for _, ign in ipairs(ignored) do
      if msg:match(ign) then return end
    end
    vim_notify(msg, ...)
  end
end)(vim.notify)
