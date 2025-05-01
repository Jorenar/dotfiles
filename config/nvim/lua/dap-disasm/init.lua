local dap = require("dap")

vim.g.dap_disasm = vim.g.dap_disasm or {
  beforeMemref = 16,
  afterMemref  = 16,
}

vim.fn.sign_define("DapDisasmPC", {text="→", texthl="debugPC", linehl="debugPC"})

local disasm_bufnr = -1
local function get_disasm_bufnr()
  if not disasm_bufnr or not vim.api.nvim_buf_is_valid(disasm_bufnr) then
    disasm_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(disasm_bufnr, "DAP Disassembly")
    vim.bo[disasm_bufnr].buftype = "nofile"
    vim.bo[disasm_bufnr].filetype = "dap_disassembly"
    vim.bo[disasm_bufnr].syntax = "asm"
  end

  return disasm_bufnr
end

local function write_buf(instructions, pc, jump_to_pc, cursor_offset)
  jump_to_pc = (jump_to_pc == nil) or jump_to_pc
  cursor_offset = cursor_offset or 0

  local lines = {}
  local pc_line = nil

  if #instructions > 0 then
    table.insert(lines, " ...")
    for i, instruction in ipairs(instructions) do
      local line = string.format(" %s:\t%s",
        instruction.address or "N/A",
        instruction.instruction or "N/A")
      table.insert(lines, line)
      if instruction.address == pc then
        pc_line = i+1  -- "+1" to account for "..." line
      end
    end
    table.insert(lines, " ...")
  end

  local buffer = get_disasm_bufnr()
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)

  vim.fn.sign_unplace("DisasmSigns", { buffer = buffer })
  if pc_line then
    vim.fn.sign_place(0, "DisasmSigns", "DapDisasmPC", buffer, {
        lnum = pc_line, priority = 10
      })

    local win = vim.fn.bufwinid(buffer)
    if win ~= -1 then
      pc_line = jump_to_pc and pc_line or vim.fn.line(".", win)
      pc_line = pc_line + cursor_offset
      vim.api.nvim_win_set_cursor(win, { pc_line, 0 })
    end
  end
end

local function render(jump_to_pc, cursor_offset)
  local session, current_frame, pc

  session = dap.session()
  if session then
    current_frame = session.current_frame
    if current_frame then
      pc = current_frame.instructionPointerReference
    end
  else
    return
  end
  if not pc then
    write_buf({}, pc)
    return
  end

  local function handler(err, res)
    if err then return end
    write_buf(res.instructions or {}, pc, jump_to_pc, cursor_offset)
  end

  local g = vim.g.dap_disasm or {}
  session:request("disassemble", {
      memoryReference = g.memref or pc,
      instructionCount = g.beforeMemref + 1 + g.afterMemref,
      instructionOffset = -g.beforeMemref,
      resolveSymbols = true,
    }, handler)
end

vim.api.nvim_create_autocmd("FileType" , {
    pattern = "dap_disassembly",
    callback = function(p)
      for _, ev in ipairs({ "scopes" }) do
        dap.listeners.after[ev]["update_disassembly"] = render
      end

      local buf = p.buf
      for _, ev in ipairs({ "disconnect", "event_exited", "event_terminated" }) do
        dap.listeners.after[ev]["update_disassembly"] = function()
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
        end
      end
    end
  })

if package.loaded["dapui"] then
  require("dapui").register_element("disassembly", {
      render = render,
      buffer = get_disasm_bufnr,
      allow_without_session = false,
    })
end

vim.api.nvim_create_user_command("DapDisasm", function(t)
  vim.cmd(t.smods.vertical and "vsplit" or "split")
  local win = vim.api.nvim_get_current_win()
  local buf = get_disasm_bufnr()
  vim.api.nvim_win_set_buf(win, buf)
  render()
end, {})
