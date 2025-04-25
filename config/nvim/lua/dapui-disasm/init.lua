local dap = require("dap")
local dapui = require("dapui")
local config = require("dapui.config")
local util = require("dapui.util")
local Canvas = require("dapui.render.canvas")

local ins = {
  count = (vim.g.dap_disasm_ins_num or 32) + 1,
  offset = -(vim.g.dap_disasm_ins_num or 32)/2 - 1,
}

vim.fn.sign_define('DapDisasmPC', {text='→', texthl='debugPC', linehl='debugPC'})

local function write_buf(instructions, pc, jump_to_pc, cursor_offset)
  local pc_line = nil
  jump_to_pc = (jump_to_pc == nil) or jump_to_pc
  cursor_offset = cursor_offset or 0

  local canvas = Canvas.new()

  for i, instruction in ipairs(instructions) do
    local line = string.format(" %s:  %s\n",
      instruction.address or "N/A",
      instruction.instruction or "N/A")
    canvas:write(line)
    if instruction.address == pc then
      pc_line = i
    end
  end

  local buffer = dapui.elements.disassembly.buffer()
  canvas:render_buffer(buffer, config.element_mapping("disassembly"))

  vim.fn.sign_unplace("DisasmSigns", { buffer = buffer })
  if pc_line then
    vim.fn.sign_place(0, "DisasmSigns", "DapDisasmPC", buffer, {
        lnum = pc_line, priority = 10
      })

    local current_line = jump_to_pc and pc_line or vim.fn.line('.')
    current_line = current_line + cursor_offset

    local win = vim.fn.bufwinid(buffer)
    if win ~= -1 then
      vim.api.nvim_win_set_cursor(win, { current_line, 0 })
    end
  end
end

local function render(jump_to_pc, cursor_offset)
  local session, current_frame, pc

  session = dap.session()
  if session then
    current_frame = session.current_frame
    if current_frame then
      pc = current_frame["instructionPointerReference"]
    end
  end
  if not pc then
    write_buf({}, pc)
    return
  end

  local function handler(err, res)
    if err then return end
    write_buf(res.instructions or {}, pc, jump_to_pc, cursor_offset)
  end
  session:request("disassemble", {
      memoryReference = pc,
      instructionCount = ins.count,
      instructionOffset = ins.offset,
      resolveSymbols = true,
    }, handler)
end

dapui.register_element("disassembly", {
  render = render,
  buffer = util.create_buffer("DAP Disassembly", {
    filetype = "dapui_disassembly",
    syntax = "asm",
  }),
  allow_without_session = false,
})

vim.api.nvim_create_autocmd("WinScrolled" , {
    buffer = dapui.elements.disassembly.buffer(),
    callback = function(e)
      local elem = dapui.elements.disassembly
      local buffer = e.buf
      local window = vim.fn.bufwinid(buffer)
      local top_line = vim.fn.getwininfo(window)[1].topline
      local height = vim.api.nvim_win_get_height(window)

      if top_line < height then
        -- We're at the top, request another page above the cursor
        ins.count = ins.count + height  -- Get increasingly more
        ins.offset = ins.offset - height
        elem.render(false, height)
      elseif top_line >= (vim.api.nvim_buf_line_count(buffer) - height) then
        -- We're at the bottom, request a new page below the cursor
        ins.count = ins.count + height  -- Get increasingly more
        ins.offset = math.min(0, ins.offset + height)
        elem.render(false)
      end
    end,
  })


for _, ev in ipairs({ "scopes", "disconnect", "event_exited", "event_terminated" }) do
  dap.listeners.after[ev]["update_disassembly"] = function()
    local elem = dapui.elements.disassembly
    if elem then
      elem.render()
    end
  end
end
