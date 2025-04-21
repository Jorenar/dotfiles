DAP = require("dap")
require('mason-nvim-dap').setup({ handlers = {} })

DAP.defaults.fallback.terminal_win_cmd = 'tab'

local dap_repl = require('dap.repl')
dap_repl.commands = vim.tbl_extend('force', dap_repl.commands, {
    help = { '.h', '.help' },
    exit = { '.q', '.quit', '.exit' },
    into = { '.s', '.into' },
    custom_commands = {
      ['.'] = function(text)
        local function handler(_, res)
          dap_repl.append(res.result:gsub('\n$',''), vim.fn.line('$')-1)
        end
        DAP.session():evaluate({ expression = '-exec ' .. text }, handler)
      end,
    },
  })

vim.fn.sign_define('DapStopped', {text='→', texthl='debugPC', linehl='', numhl='debugPC'})

vim.api.nvim_set_hl(0, "DapUIRestart", { link = "DapUIRestartNC" }) -- needs to be set before dapui

local DAPUI = require("dapui")
DAPUI.setup({
    expand_lines = false,
    force_buffers = true,
    controls = {
      element = "repl",
      enabled = true,
      icons = {
        play = "Cont",
        pause = "Pause",
        step_into = "Into",
        step_over = "Over",
        step_out = "Out",
        step_back = "Back",
        run_last = "Re-run",
        disconnect = "Disconnect",
        terminate = "Terminate",
      }
    },
    floating = {
      border = "single",
      mappings = {
        close = { "<Esc>" }
      }
    },
    icons = {
      collapsed = ">",
      current_frame = ">",
      expanded = "-"
    },
    layouts = {
      {
        elements = {
          { id = "stacks", size = 0.25 },
          { id = "scopes", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        position = "top",
        size = 10
      },
      {
        elements = {
          { id = "console", size = 0.4 },
          { id = "repl", size = 0.6 },
        },
        position = "right",
        size = 70,
      },
    },
    mappings = {
      edit = "cc",
      expand =  "za" ,
      remove = "dd",
      repl = "<leader>r",
    },
    element_mappings = {
      stacks = {
        open = { "gd", "<CR>", "<2-LeftMouse>" },
      },
      scopes = {
        expand = { "<CR>", "za", "<2-LeftMouse>" },
      },
      breakpoints = {
        open = { "gd", "<CR>", "<2-LeftMouse>" },
        toggle = "t"
      },
    },
    render = {
      indent = 2,
      max_value_lines = 100
    }
  })

DAP.listeners.before.attach.dapui_config = function()
  DAPUI.open()
end
DAP.listeners.before.launch.dapui_config = function()
  DAPUI.open()
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-repl", "dapui_*" },
    callback = function()
      vim.api.nvim_create_autocmd("BufEnter", {
          once = true,
          pattern = "<buffer>",
          callback = function()
            vim.opt_local.statusline = ' %f'
          end,
        })
    end,
  })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-repl",
    once = true,
    callback = function()
      local dap_brp = require('dap.breakpoints')

      local function check_brkpts(line)
        local pattern = 'Breakpoint %d+ at 0x[0-9A-Fa-f]+: file (.+), line (%d+)'
        local file, lnum = line:match(pattern)
        if not file or not lnum then
          return false
        end
        local bufnr = vim.fn.bufnr(file, true)
        if not vim.bo[bufnr].buflisted then
          vim.fn.bufload(bufnr)
        end
        dap_brp.set({}, bufnr, tonumber(lnum))
        return true
      end

      local function check_watches(line)
        local expr = line:match('Watchpoint %d+: (.+)')
        if expr then
          DAPUI.elements.watches.add(expr)
        end
      end

      vim.api.nvim_buf_attach(0, false, {
        on_lines = function(_, buf, _, st, _, ed, _)
          local new_lines = vim.api.nvim_buf_get_lines(buf, st, ed, false)
          local should_ui_refresh = false

          for _, line in ipairs(new_lines) do
            should_ui_refresh = check_brkpts(line) or should_ui_refresh
            check_watches(line)
          end

          if should_ui_refresh then
            vim.schedule(DAPUI.elements.breakpoints.render)
          end
        end,
      })
    end,
  })

local KEYMAPS = {
  { 'n', '<leader>d',  ':lua DAP.()<left><left>' },
  { 'n', '<leader>d:', ':lua DAP.()<left><left>' },
  { 'n', '<leader>dr', DAP.run_to_cursor },
  { 'n', '<leader>db', DAP.toggle_breakpoint },
  { 'n', '<leader>dc', DAP.continue },
  { 'n', '<leader>dn', DAP.step_over },
  { 'n', '<leader>ds', DAP.step_into },
  { 'n', '<leader>de', DAPUI.eval },
  { 'n', '<leader>T', function()
      DAPUI.float_element('console', {
        width = vim.o.columns - 10,
        height = vim.o.lines - 10,
        position = 'center',
      })
    end },
}
for _,k in ipairs(KEYMAPS) do
  vim.keymap.set(k[1], k[2], k[3], { noremap = true })
end

vim.cmd [[
  anoremenu PopUp.DAP\ Toggle\ Breakpoint <cmd>lua DAP.toggle_breakpoint()<CR>
]]

vim.api.nvim_create_user_command('DapuiToggle', DAPUI.toggle, {})
