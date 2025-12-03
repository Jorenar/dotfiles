-- handlers & helpers {{{

-- vim.lsp.set_log_level("debug")

local cfg = vim.lsp.config

local GP = require('goto-preview')
GP.setup {
  focus_on_open = false,
  dismiss_on_move = true,
  preview_window_title = { enable = false },
}

vim.api.nvim_create_autocmd({"BufReadPre", "FileType", "VimEnter"}, {
    once = true,
    callback = function(e)
      vim.api.nvim_del_autocmd(e.id)
      for name,_ in pairs(vim.g.enabled_lsp) do
        if vim.lsp.config[name] then
          vim.lsp.enable(name, vim.fn.EnabledLsp(name))
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

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      if not vim.lsp.inline_completion then return end

      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
        vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

        vim.keymap.set('i', '<C-F>', vim.lsp.inline_completion.get,
          { desc = 'LSP: accept inline completion', buffer = bufnr })
        vim.keymap.set('i', '<C-G>', vim.lsp.inline_completion.select,
          { desc = 'LSP: switch inline completion', buffer = bufnr })
      end
    end
  })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      elseif client.name == 'ccls' then
        if not vim.fn.EnabledLsp('clangd') then return end
        client.server_capabilities = {
          completionProvider = client.server_capabilities.completionProvider,
          textDocumentSync = client.server_capabilities.textDocumentSync,
        }
      elseif client.name == 'clangd' then
        if not vim.fn.EnabledLsp('ccls') then return end
        client.server_capabilities.completionProvider = nil
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

cfg("copilot", {
  settings = { telemetry = { telemetryLevel = "off" } }
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
  cmd = { 'groovy-language-server' },
})

cfg("harper_ls", {
  settings = {
    ["harper-ls"] = {
      userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
      linters = {
        Dashes = false,
        HaveTakeALook = false,
        NoFrenchSpaces = false,
        SentenceCapitalization = false,
        Spaces = false,
        SpellCheck = false,
        SplitWords = false,
        ToDoHyphen = false,
        ToTwoToo = false,
      }
    }
  },
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
  root_markers = {
    '.emmyrc.json',
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    'init.vim',
    'init.lua',
    '.git',
  },
  settings = { Lua = {} }
})

cfg("sqls", {
  cmd = { "sqls", "-config", ".sqls.yml" },
  on_attach = function(client, bufnr)
    require('sqls').on_attach(client, bufnr)
  end
})

local ok, sonarlint = pcall(require, 'sonarlint')
if ok and vim.fn.EnabledLsp('sonarlint') then
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
          rules = {
            ["python:S1542"] = { level = "off" }, -- Rename to match the regular expression ^[a-z_][a-z0-9_]*$.
            ["javascript:S7764"] = { level = "off" }, -- Prefer `globalThis` over `window`
          },
        },
      },
      root_dir = vim.fs.root(0, { ".git", ".compile_commands.json" }),
      on_attach = function()
        if vim.fn.exists(':SonarlintListRules') ~= 0 then
          vim.api.nvim_del_user_command('SonarlintListRules')
          vim.api.nvim_create_user_command("LspSonarlintListRules",
            require('sonarlint.rules').list_all_rules, {})
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

        local cjar = vim.env.MASON .. '/packages/sonarlint-language-server/extension/analyzers/sonarcfamily.jar'
        if vim.fn.filereadable(cjar) == 0 then
          local pkgjson = vim.env.MASON .. '/packages/sonarlint-language-server/extension/package.json'
          for _,a in ipairs(vim.json.decode(table.concat(vim.fn.readfile(pkgjson), '\n')).jarDependencies) do
            if a.artifactId == 'sonar-cfamily-plugin' then
              vim.system({'curl', '-o', cjar, '-L', 'https://binaries.sonarsource.com/CommercialDistribution/sonar-cfamily-plugin/sonar-cfamily-plugin-'..a.version..'.jar'})
              vim.system({'ln', '-sf', cjar, vim.env.MASON .. '/share/sonarlint-analyzers/sonarcfamily.jar'})
              break
            end
          end
        end
      end,
    },
    filetypes = { '*' },
  })
end
