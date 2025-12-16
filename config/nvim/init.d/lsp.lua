--[[ ]]-- {{{

vim.lsp.log.set_level(vim.log.levels.ERROR)

vim.lsp.inline_completion.enable(true)
vim.lsp.linked_editing_range.enable(false)
vim.lsp.on_type_formatting.enable(false)
vim.lsp.semantic_tokens.enable(false)

local GP = require('goto-preview')
GP.setup {
  focus_on_open = false,
  dismiss_on_move = true,
  preview_window_title = { enable = false },
}

local masonPacks = require("mason-registry").get_installed_packages()
vim.g.lsp_servers = vim.iter(masonPacks):fold({}, function(acc, pack)
  table.insert(acc, pack.spec.neovim and pack.spec.neovim.lspconfig)
  return acc
end)

vim.api.nvim_create_autocmd({ "BufReadPre", "FileType", "VimEnter" }, {
  once = true,
  callback = function(e)
    vim.api.nvim_del_autocmd(e.id)
    for _,name in ipairs(vim.g.lsp_servers) do
      vim.lsp.enable(name)
      if vim.tbl_contains(vim.lsp.config[name].filetypes or {}, "*") then
        vim.lsp.config[name].filetypes = nil
      end
    end
  end
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    vim.lsp.document_color.enable(false, args.buf)

    if client.server_capabilities['completionProvider'] then
      vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end

    if vim.bo[args.buf].tagfunc == 'v:lua.vim.lsp.tagfunc' then
      vim.bo[args.buf].tagfunc = ''
    end

    local K = vim.fn.maparg('K', 'n', false, true)
    if K and K.buffer == 1 and K.desc == "vim.lsp.buf.hover()" then
      pcall(vim.api.nvim_buf_del_keymap, args.buf, 'n', 'K')
    end
  end
})

vim.g.notify_ignore = vim.tbl_extend("keep", vim.g.notify_ignore or {}, {
  "warning: multiple different client offset_encodings",
  "SonarQube language server is ready.",
  "Couldn't find compile_commands.json. Make sure it exists in a parent directory.",
})

local my_onlist = function(opts)
  opts.items = vim.list.unique(opts.items, function(val)
    return val.filename .. ':' .. val.lnum
  end)
  if #opts.items == 1 then
    local item = opts.items[1]
    vim.lsp.util.show_document({
      uri = vim.uri_from_fname(item.filename),
      range = {
        ["start"] = { character = item.col - 1, line = item.lnum - 1 },
        ["end"] = { character = item.end_col - 1, line = item.end_lnum - 1 },
      },
    }, 'utf-8')
  else
    vim.fn.setqflist({}, ' ', opts)
    vim.cmd.copen()
  end
end

local cfg = function(name, ...)
  vim.lsp.config(name, ...)
  local tmp = vim.g.lsp_servers
  table.insert(tmp, name)
  vim.g.lsp_servers = tmp
end

-- }}}

--[[ KEYMAPS ]] for _,k in ipairs({

  { 'n', 'L', "<Cmd>exec {l -> empty(l) ? '' : 'norm L'.l}(input('L'))<CR>" },

  { 'n', 'LK',  function() vim.lsp.buf.hover({ border = "single" }) end },
  { 'n', 'LR',  vim.lsp.buf.rename },

  { 'n', 'Lca', vim.lsp.buf.code_action },

  { 'n', 'Lgg', function() vim.lsp.buf.definition({on_list=my_onlist}) end },
  { 'n', 'Lgd', function() vim.lsp.buf.declaration({on_list=my_onlist}) end },
  { 'n', 'Lgi', function() vim.lsp.buf.implementation({on_list=my_onlist}) end },
  { 'n', 'Lgt', function() vim.lsp.buf.type_definition({on_list=my_onlist}) end },

  { 'n', 'Lkg', GP.goto_preview_definition },
  { 'n', 'Lkd', GP.goto_preview_declaration },
  { 'n', 'Lki', GP.goto_preview_implementation },
  { 'n', 'Lkt', GP.goto_preview_type_definition },

  { 'n', 'Lfr', vim.lsp.buf.references },
  { 'n', 'Lfs', vim.lsp.buf.workspace_symbol },
  { 'n', 'Lfi', vim.lsp.buf.incoming_calls },
  { 'n', 'Lfo', vim.lsp.buf.outgoing_calls },

  { 'i', '<C-F>', vim.lsp.inline_completion.get },
  { 'i', '<C-G>', vim.lsp.inline_completion.select },

}) do
  vim.keymap.set(k[1], k[2], k[3], { noremap = true })
end


--[[ CONFIGS ]]

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
    if vim.fn.expand('%:p'):match('nvim') then
      client.settings.Lua = vim.tbl_deep_extend('force', client.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        }
      })
    end
  end,
  settings = { Lua = {} }
})

cfg("sqls", {
  cmd = (function()
    local yml = vim.fs.find({ "sqls.yml", ".sqls.yml" }, { upward = true })
    return (#yml > 0) and { "sqls", "-config", yml[1] } or { "sqls" }
  end)(),
})

local ok, sonarlint = pcall(require, 'sonarlint')
if ok and vim.fn.executable('sonarlint-language-server') then
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
