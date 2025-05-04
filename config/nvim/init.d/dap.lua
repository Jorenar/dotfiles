local dap = require("dap")
local dapui = require("dapui")
local dap_repl = require('dap.repl')

require('mason-nvim-dap').setup({ handlers = {} })
require('dap-disasm').setup({
    ins_before_memref = 64,
    ins_after_memref = 64,
    columns = { "address", "instruction" },
  })

-- REPL & terminal {{{1

dap.defaults.fallback.external_terminal = {
  command = "tmux", args = { "split", "-hb" },
}

dap_repl.commands = vim.tbl_extend('force', dap_repl.commands, {
    help = { '.h', '.help' },
    exit = { '.q', '.quit', '.exit' },
    into = { '.s', '.into' },
  })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-repl",
    once = true,
    callback = function()
      vim.keymap.set('i', '<C-l>', function()
        vim.opt_local.scrolloff = 0
        vim.cmd('normal! Gzt')
      end, { buffer = 0 })
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
          dapui.elements.watches.add(expr)
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
            vim.schedule(dapui.elements.breakpoints.render)
          end
        end,
      })
    end,
  })

-- UI {{{1

dapui.setup({
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
      },
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
        size = 6,
      },
      {
        elements = {
          { id = "console", size = 0.5 },
          { id = "repl", size = 0.5 },
        },
        position = "right",
        size = 0.4,
      },
      {
        elements = { { id = "disassembly" } },
        position = "bottom",
        size = 0.15,
      },
    },
    mappings = {
      edit = "cc",
      expand =  "za" ,
      remove = "dd",
      repl = "<F5>",
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
      disassembly = {
        expand = "<CR>"
      },
    },
    render = {
      indent = 2,
      max_value_lines = 100
    },
  })

vim.api.nvim_set_hl(0, "DapUIRestartNC", { bold = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-repl", "dapui_*", "dap_disassembly" },
    callback = function(E)
      vim.api.nvim_create_autocmd("BufEnter", {
          once = true,
          pattern = "<buffer>",
          callback = function()
            vim.opt_local.statusline = ' %f'
            if E.match == "dap_disassembly" then
              vim.opt_local.statusline = ' %f %= %l/%L '
            end
            vim.opt_local.foldmethod = 'expr'
          end,
        })
    end,
  })

local function openUI()
  dapui.close()
  dapui.open()
end

dap.listeners.before.attach.dapui_config = openUI
dap.listeners.before.launch.dapui_config = openUI

vim.api.nvim_create_user_command('DapuiClose', dapui.close, {})
vim.api.nvim_create_user_command('DapuiToggle', dapui.toggle, {})

-- mappings {{{1

local float_winopts = {
  enter = true,
  width = vim.o.columns - 10,
  height = vim.o.lines - 10,
  position = 'center',
}

for _,k in ipairs({
  { 'n', '<leader>d',  ':lua require("dap").()<left><left>' },
  { 'n', '<leader>d:', ':lua require("dap").()<left><left>' },
  { 'n', '<leader>dr', dap.run_to_cursor },
  { 'n', '<leader>db', dap.toggle_breakpoint },
  { 'n', '<Leader>df', dap.focus_frame },
  { 'n', '<leader>dk', dapui.eval },
  { 'n', '<leader>dwt', function()
      dapui.float_element('console', float_winopts)
    end
  },
  { 'n', '<Leader>dwf', function()
      dapui.float_element('stacks', float_winopts)
    end
  },
  { 'n', '<Leader>dws', function()
      dapui.float_element('scopes', float_winopts)
    end
  },
  { 'n', '<Leader>dww', function()
      dapui.float_element('watches', float_winopts)
    end
  },
  { 'n', '<Leader>dwb', function()
      dapui.float_element('breakpoints', float_winopts)
    end
  },
  { 'n', '<Leader>dwa', function()
      dapui.float_element('disassembly', float_winopts)
    end
  },
}) do
  vim.keymap.set(k[1], k[2], k[3], { noremap = true })
end

vim.cmd [[
  anoremenu PopUp.DAP\ Toggle\ Breakpoint <cmd>lua require("dap").toggle_breakpoint()<CR>
]]

-- misc {{{1

vim.fn.sign_define('DapStopped', {text='→', texthl='debugPC', linehl='', numhl='debugPC'})

vim.api.nvim_create_user_command("DapSessions", function()
  local widgets = require('dap.ui.widgets')
  local session_picker = widgets.centered_float(widgets.sessions, {})
  vim.keymap.set('n', '<Esc>', '<Cmd>q<CR>', { buffer = session_picker.buf })
  vim.keymap.set('n', '<CR>', function()
    require('dap.ui').trigger_actions({ mode = 'first' })
    dap.focus_frame()
  end, { buffer = session_picker.buf })
end, { nargs = 0 })
