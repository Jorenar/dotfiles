-- handlers & helpers {{{

-- vim.lsp.set_log_level("debug")

local cfg = vim.lsp.config

local GP = require('goto-preview')
GP.setup {
  focus_on_open = false,
  dismiss_on_move = true,
  preview_window_title = { enable = false },
}

local function isServEnabled(client)
  local function check(name)
    local val = vim.g.enabled_lsp and vim.g.enabled_lsp[name]
    if vim.fn.type(val) == vim.v.t_dict and vim.fn.empty(val) then
      val = vim.fn.executable(name)
    elseif val == vim.NIL then
      val = vim.fn.eval('g:enabled_lsp["'..name..'"]()')
    end
    return not (val == 0 or val == false or val == nil or val == vim.NIL)
  end
  local name = (client.name and client.name or client)
  return check(name) or check(name:gsub('_', '-'))
end

vim.api.nvim_create_autocmd({"BufReadPre", "FileType", "VimEnter"}, {
    once = true,
    callback = function(e)
      vim.api.nvim_del_autocmd(e.id)
      for name,_ in pairs(vim.g.enabled_lsp) do
        if vim.lsp.config[name] then
          vim.lsp.enable(name, isServEnabled(name))
          if vim.tbl_contains(vim.lsp.config[name].filetypes or {"*"}, "*") then
            vim.lsp.config[name].filetypes = nil
          end
        end
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
    end
  })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      elseif client.name == 'ccls' then
        if not isServEnabled('clangd') then return end
        client.server_capabilities = {
          completionProvider = client.server_capabilities.completionProvider,
          textDocumentSync = client.server_capabilities.textDocumentSync,
        }
      elseif client.name == 'clangd' then
        if not isServEnabled('ccls') then return end
        client.server_capabilities.completionProvider = nil
      end
    end
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

    pcall(vim.fn['ale#other_source#ShowResults'], bufnr,
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

--[[ KEYMAPS ]] for _,k in ipairs({

  { 'n', 'L', "<Cmd>exec {l -> empty(l) ? '' : 'norm L'.l}(input('L'))<CR>" },

  { 'n', 'LK',  function() vim.lsp.buf.hover({ border = "single" }) end },
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

}) do
  vim.keymap.set(k[1], k[2], k[3], { noremap = true })
end


--[[ SERVERS' CONFIGS ]]

cfg("asm_lsp", {
  filetypes = { "asm", "nasm", "masm", "vmasm" },
})

cfg("ast_grep", {
  cmd = {
    'ast-grep', 'lsp',
    '-c', vim.env.XDG_CONFIG_HOME .. '/ast-grep/sgconfig.yml'
  },
  filetypes = { '*' },
  workspace_required = false,
})

cfg("ccls", {
  init_options = {
    cache = { directory = '.cache/ccls' },
    clang = { extraArgs = { '--gcc-toolchain=/usr' } },
  },
})

cfg("clangd", {
  cmd = { "clangd",
    "--header-insertion-decorators=false",
    "--background-index",
  },
})

cfg("denols", {
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
})

cfg("groovyls", {
  cmd = {
    "java", "-jar",
    vim.env.XDG_DATA_HOME .. '/java/groovy-language-server-all.jar'
  },
})

cfg("harper_ls", {
  settings = {
    ["harper-ls"] = {
      userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
    }
  },
  filetypes = { '*' },
})

cfg("lua_ls", {
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
})

cfg("sqls", {
  cmd = { "sqls", "-config", ".sqls.yml" },
  on_attach = function(client, bufnr)
    require('sqls').on_attach(client, bufnr)
  end
})

local ok, sonarlint = pcall(require, 'sonarlint')
if ok and isServEnabled('sonarlint') then
  sonarlint.setup({
    server = {
      cmd = {
        'java', '-Duser.home=' .. vim.env.XDG_CACHE_HOME,
        '-jar', vim.env.MASON .. '/packages/sonarlint-language-server/extension/server/sonarlint-ls.jar',
        '-stdio', '-analyzers', unpack(vim.fn.glob('$MASON/share/sonarlint-analyzers/*.jar', true, true)),
      },
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
      root_dir = vim.fs.root(0, { ".git", ".compile_commands.json" }),
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
    filetypes = { '*' },
  })
end
