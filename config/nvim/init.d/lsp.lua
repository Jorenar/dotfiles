-- vim.lsp.set_log_level("debug")

-- handlers & helpers {{{

local KEYMAPS, SERVERS

local LSPCONFIG = require('lspconfig')
local GP = require('goto-preview')

GP.setup {
  focus_on_open = false,
  dismiss_on_move = true,
  preview_window_title = { enable = false },
}

local function isServEnabled(client)
  local function check(name)
    local val = vim.g.enabled_lsp[name]
    return not (val == 0 or val == false or val == nil)
  end
  local name = (client.name and client.name or client)
  return check(name) or check(name:gsub('_', '-'))
end

local function setupServ(name, conf)
  if not isServEnabled(name) then return end

  if name == 'sonarlint' then
    require('sonarlint').setup(conf)
    return
  end

  if name == 'jedi' then
    name = 'jedi_language_server'
  end

  LSPCONFIG[name].setup(conf)

  return LSPCONFIG[name]
end

vim.api.nvim_create_autocmd({"BufReadPre", "FileType", "VimEnter"}, {
    once = true,
    callback = function(e)
      vim.api.nvim_del_autocmd(e.id)  -- delete au for other events

      local start = (e.event == "FileType") and function(s)
        if not s.autostart then return end
        if s.filetypes and vim.tbl_contains(s.filetypes, e.match) then
          s.launch()
        end
      end

      for name, conf in pairs(SERVERS) do
        local serv = setupServ(name, conf)
        if start and serv then start(serv) end
      end
    end
  })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end

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

      for _,k in ipairs(KEYMAPS) do
        vim.keymap.set(k[1], k[2], k[3], { buffer = true, noremap = true })
      end
    end
  })

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    focusable = false,
    border = "single"
  })

vim.lsp.handlers["textDocument/publishDiagnostics"] = (function(diag_handler)
  local function ale_map(e)
    return {
      text     = e.message,
      detail   = vim.inspect(e),
      lnum     = e.range["start"].line + 1,
      end_lnum = e.range["end"].line + 1,
      col      = e.range["start"].character + 1,
      end_col  = e.range["end"].character,
      type = ({
          [vim.diagnostic.severity.ERROR] = 'E',
          [vim.diagnostic.severity.WARN]  = 'W',
          [vim.diagnostic.severity.INFO]  = 'I',
          [vim.diagnostic.severity.HINT]  = 'I',
        })[e.severity]
    }
  end
  return function(err, res, ctx, conf)
    local bufnr = vim.fn.bufnr(res.uri:gsub('^file://', ''), false)
    if bufnr == -1 then return end

    vim.fn['ale#other_source#ShowResults'](bufnr,
      vim.lsp.get_client_by_id(ctx.client_id).name,
      vim.tbl_map(ale_map, vim.deepcopy(res.diagnostics))
    )

    return diag_handler(err, res, ctx, conf)
  end
end)(vim.lsp.handlers["textDocument/publishDiagnostics"])

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

-- }}}


KEYMAPS = {
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

SERVERS = {

  digestif = {},
  gopls = {},
  jdtls = {},
  jedi = {},
  openscad_lsp = {},
  texlab = {},
  vimls = {},

  asm_lsp = {
    filetypes = { "asm", "nasm", "masm", "vmasm" },
  },

  ast_grep = {
    cmd = {
      'ast-grep', 'lsp',
      '-c', vim.env.XDG_CONFIG_HOME .. '/ast-grep/sgconfig.yml'
    },
    root_dir = function(fname)
      return vim.fs.root(fname, {
          'sgconfig.yaml', 'sgconfig.yml', '.git'
        }) or '.'
    end,
    filetypes = { '*' }
  },

  ccls = {
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
  },

  clangd = {
    cmd = { "clangd",
      "--header-insertion-decorators=false",
      "--background-index",
    },
    on_attach = function(client, _)
      if not isServEnabled('ccls') then return end
      client.server_capabilities.completionProvider = nil
    end
  },

  denols = {
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
    },
    single_file_support = true,
  },

  groovyls = {
    cmd = {
      "java", "-jar",
      vim.env.XDG_DATA_HOME .. '/java/groovy-language-server-all.jar'
    },
  },

  lua_ls = {
    on_init = function(client)
      if not (client.workspace_folders[1].name:match('nvim')
          or vim.fn.expand('%:p'):match('nvim')) then
        return
      end

      client.settings.Lua = vim.tbl_deep_extend('force', client.settings.Lua, {
          runtime = { version = 'LuaJIT' },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          }
        })
    end,
    settings = { Lua = {} }
  },

  sqls = {
    cmd = {"sqls", "-config", ".sqls.yml"},
    on_attach = function(client, bufnr)
      require('sqls').on_attach(client, bufnr)
    end
  },

  sonarlint = {
    server = {
      cmd = (function(dir) return {
            'java',
            '-Duser.home=' .. vim.env.XDG_CACHE_HOME,
            '-jar', dir .. '/sonarlint-ls.jar',
            '-stdio',
            '-analyzers',
            unpack(vim.fn.glob(dir .. '/analyzers/*.jar', true, true)),
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
      on_attach = function()
        if vim.fn.exists(':SonarlintListRules') ~= 0 then
          vim.api.nvim_del_user_command('SonarlintListRules')
        end
      end,
      before_init = function()
        local dir = vim.fs.joinpath(vim.env.XDG_CACHE_HOME, '.sonarlint')
        local t = vim.fs.joinpath(dir, 'telemetry')
        if vim.fn.filereadable(t) == 0 then
          vim.fn.mkdir(dir, 'p')
          io.open(t, "w"):close()
        end
        vim.fn.setfperm(t, 'r--r--r--')
      end,
    },
    filetypes = { '*' }
  },

}
