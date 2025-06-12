if not pcall(require, "dap") then
  return
end

local dap = require("dap")
local dapui = require("dapui")
local dap_repl = require('dap.repl')
local dap_disasm = require('dap-disasm')

require('mason-nvim-dap').setup({ handlers = {} })

dap_disasm.setup({
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
    into = { '.s', '.step', '.into' },
  })

dap_repl.commands.custom_commands = vim.tbl_extend('force',
  dap_repl.commands.custom_commands,
  {
    [".ni"] = dap_disasm.step_over,
    [".si"] = dap_disasm.step_into,
    [".bi"] = dap_disasm.step_back,
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

--[[
local function get_fn_local_var(fn, target_name)
  local i = 1
  while true do
    local name, value = debug.getupvalue(fn, i)
    if not name then
      break
    elseif name == target_name then
      return value
    end
    i = i + 1
  end
end
]]--

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
      remove = "dd",
      expand = { "<2-LeftMouse>" },
      repl = "<F5>",
    },
    element_mappings = {
      stacks = {
        open = { "gd", "<CR>", "<2-LeftMouse>" },
      },
      scopes = {
        expand = { "<CR>", "<2-LeftMouse>" },
      },
      breakpoints = {
        open = { "gd", "<CR>", "<2-LeftMouse>" },
        toggle = "t"
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
            vim.opt_local.foldmethod = 'manual'
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

vim.api.nvim_create_user_command('DapuiOpen', function(t)
  dapui.close()
  dapui.open({ reset = t.bang })
end, { bang = true })
vim.api.nvim_create_user_command('DapuiClose', dapui.close, {})
vim.api.nvim_create_user_command('DapuiToggle', dapui.toggle, {})

-- mappings {{{1

local function mappings()

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
      { 'x', '<leader>dk', dapui.eval },
      { 'n', '<leader>dT', function()
          dapui.float_element('console', float_winopts)
        end
      },
      { 'n', '<Leader>dF', function()
          dapui.float_element('stacks', float_winopts)
        end
      },
      { 'n', '<Leader>dS', function()
          dapui.float_element('scopes', float_winopts)
        end
      },
      { 'n', '<Leader>dW', function()
          dapui.float_element('watches', float_winopts)
        end
      },
      { 'n', '<Leader>dB', function()
          dapui.float_element('breakpoints', float_winopts)
        end
      },
      { 'n', '<Leader>dA', function()
          dapui.float_element('disassembly', float_winopts)
        end
      },
    }) do
    vim.keymap.set(k[1], k[2], k[3], { noremap = true })
  end

  vim.cmd [[ anoremenu PopUp.DAP\ Toggle\ Breakpoint <cmd>lua require("dap").toggle_breakpoint()<CR> ]]

end

dap.listeners.before.attach.mappings = mappings
dap.listeners.before.launch.mappings = mappings

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
