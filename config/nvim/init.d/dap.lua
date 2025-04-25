DAP = require("dap")
require('mason-nvim-dap').setup({ handlers = {} })

DAP.defaults.fallback.external_terminal = {
  command = "tmux", args = { "split", "-hb" },
}

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
      ['.restart'] = DAP.restart,
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
    },
    render = {
      indent = 2,
      max_value_lines = 100
    },
  })

local function openUI()
  DAPUI.open()
end

DAP.listeners.before.attach.dapui_config = openUI
DAP.listeners.before.launch.dapui_config = openUI

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-repl", "dapui_*" },
    callback = function()
      vim.api.nvim_create_autocmd("BufEnter", {
          once = true,
          pattern = "<buffer>",
          callback = function()
            vim.opt_local.statusline = ' %f'
            vim.opt_local.foldmethod = 'expr'
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


local float_default = {
  enter = true,
  width = vim.o.columns - 10,
  height = vim.o.lines - 10,
  position = 'center',
}

local KEYMAPS = {
  { 'n', '<leader>d',  ':lua DAP.()<left><left>' },
  { 'n', '<leader>d:', ':lua DAP.()<left><left>' },
  { 'n', '<leader>dr', DAP.run_to_cursor },
  { 'n', '<leader>db', DAP.toggle_breakpoint },
  { 'n', '<leader>dk', DAPUI.eval },
  { 'n', '<leader>dt', function()
      DAPUI.float_element('console', float_default)
    end
  },
  { 'n', '<Leader>df', function()
      DAPUI.float_element('stacks', float_default)
    end
  },
  { 'n', '<Leader>ds', function()
      DAPUI.float_element('scopes', float_default)
    end
  },
  { 'n', '<Leader>dw', function()
      DAPUI.float_element('watches', float_default)
    end
  },
  { 'n', '<Leader>dB', function()
      DAPUI.float_element('breakpoints', float_default)
    end
  },
  { 'n', '<Leader>da', function()
      DAPUI.float_element('disassembly', float_default)
    end
  },
}
for _,k in ipairs(KEYMAPS) do
  vim.keymap.set(k[1], k[2], k[3], { noremap = true })
end

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

vim.cmd [[
  anoremenu PopUp.DAP\ Toggle\ Breakpoint <cmd>lua DAP.toggle_breakpoint()<CR>
]]

vim.api.nvim_create_user_command('DapuiToggle', DAPUI.toggle, {})


---- Disassembly ----

local DISASM_BUFNR = -1
vim.g.dap_disasm_ins_num = 32

vim.fn.sign_define('DapDisasmPC', {text='→', texthl='debugPC', linehl='debugPC'})

local function disasm_bufnr()
  if not vim.api.nvim_buf_is_valid(DISASM_BUFNR or -1) then
    DISASM_BUFNR = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(DISASM_BUFNR, "DAP Disassembly")
    vim.bo[DISASM_BUFNR].buftype = "nofile"
    vim.bo[DISASM_BUFNR].filetype = "dapui_disassembly"
    vim.bo[DISASM_BUFNR].syntax = "asm"
  end
  return DISASM_BUFNR
end

local function disasm_write_buf(instructions, pc)
  local lines = {}
  local current_line = nil

  table.insert(lines, " ...")
  for i, instruction in ipairs(instructions) do
    local line = string.format(" %s:\t%s",
      instruction.address or "N/A",
      instruction.instruction or "N/A")
    table.insert(lines, line)
    if instruction.address == pc then
      current_line = i
    end
  end
  table.insert(lines, " ...")

  local buffer = disasm_bufnr()
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)

  vim.fn.sign_unplace("DisasmSigns", { buffer = buffer })

  if current_line then
    vim.fn.sign_place(0, "DisasmSigns", "DapDisasmPC", buffer, {
        lnum = current_line, priority = 10
      })

    local win = vim.fn.bufwinid(buffer)
    if win ~= -1 then
      vim.api.nvim_win_set_cursor(win, { current_line + 1, 0 })
    end
  end
end

local function render_disasm()
  local session = DAP.session()
  if not session then return end
  local current_frame = session.current_frame
  if not current_frame then return end
  local pc = current_frame["instructionPointerReference"]
  if not pc then return end

  local inum = vim.g.dap_disasm_ins_num
  local function handler(err, res)
    if err then
      vim.api.nvim_err_writeln("Disassembly error: " .. vim.inspect(err))
      return
    end
    disasm_write_buf(res.instructions or {}, pc)
  end
  DAP.session():request("disassemble", {
      instructionCount = inum + 1,
      memoryReference = pc,
      resolveSymbols = true,
      instructionOffset = -inum/2 - 1,
    }, handler)
end

DAPUI.register_element("disassembly", {
  render = render_disasm,
  buffer = disasm_bufnr,
  allow_without_session = false,
})

for _, ev in ipairs({ "breakpoint", "event_stopped", "output", "scopes", "stackTrace", "threads", })
do
  DAP.listeners.after[ev]["update_disassembly"] = function()
    local disasm_element = DAPUI.elements.disassembly
    if disasm_element then
      disasm_element.render()
    end
  end
end

for _, ev in ipairs({ "disconnect", "event_exited", "event_terminated", })
do
  DAP.listeners.after[ev]["update_disassembly"] = function()
    if vim.api.nvim_buf_is_valid(DISASM_BUFNR or -1) then
      vim.api.nvim_buf_set_lines(DISASM_BUFNR, 0, -1, false, {})
    end
  end
end
