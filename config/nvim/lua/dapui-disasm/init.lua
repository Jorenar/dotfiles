local dap = require("dap")
local dapui = require("dapui")
local config = require("dapui.config")
local util = require("dapui.util")
local Canvas = require("dapui.render.canvas")

local cache = {
  _frameId = 0,
  _default = {
    count = 16+1,
    offset = -8,
  }
}

local function get_cache()
  return cache[cache._frameId]
end

vim.fn.sign_define('DapDisasmPC', {text='→', texthl='debugPC', linehl='debugPC'})

local function write_buf(instructions, pc, jump_to_pc, cursor_offset)
  local pc_line = nil
  jump_to_pc = (jump_to_pc == nil) or jump_to_pc
  cursor_offset = cursor_offset or 0

  local canvas = Canvas.new()

  if #instructions > 0 then
    local step = 32
    canvas:add_mapping("expand", function()
      get_cache().count = get_cache().count + step
      get_cache().offset = get_cache().offset - step
      dapui.elements.disassembly.render(false, step)
    end)
    canvas:write("[load more]\n")

    for i, instruction in ipairs(instructions) do
      local line = string.format(" %s:  %s\n",
        instruction.address or "N/A",
        instruction.instruction or "N/A")
      canvas:write(line)
      if instruction.address == pc then
        pc_line = i+1
      end
    end

    canvas:add_mapping("expand", function()
      get_cache().count = get_cache().count + step
      -- get_cache().offset = get_cache().count + step
      -- get_cache().offset = math.min(0, get_cache().offset + step)
      dapui.elements.disassembly.render(false)
    end)
    canvas:write("[load more]")
  end

  local buffer = dapui.elements.disassembly.buffer()
  canvas:render_buffer(buffer, config.element_mapping("disassembly"))

  vim.fn.sign_unplace("DisasmSigns", { buffer = buffer })
  if pc_line then
    vim.fn.sign_place(0, "DisasmSigns", "DapDisasmPC", buffer, {
        lnum = pc_line, priority = 10
      })

    local win = vim.fn.bufwinid(buffer)
    if win ~= -1 then
      local current_line = jump_to_pc and pc_line or vim.fn.line('.', win)
      current_line = current_line + cursor_offset
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
      pc = current_frame.instructionPointerReference
    end
  else
    return
  end
  if not pc then
    write_buf({}, pc)
    return
  end

  if not cache[current_frame.id] then
    cache._frameId = current_frame.id
    cache[current_frame.id] = cache._default
  end
  local function handler(err, res)
    if err then return end
    write_buf(res.instructions or {}, pc, jump_to_pc, cursor_offset)
  end
  session:request("disassemble", {
      memoryReference = pc,
      instructionCount = get_cache().count,
      instructionOffset = get_cache().offset,
      resolveSymbols = true,
    }, handler)
end

vim.api.nvim_create_autocmd("FileType" , {
    pattern = "dapui_disassembly",
    callback = function(p)
      local buf = p.buf

      vim.bo[buf].syntax = "asm"

      for _, ev in ipairs({ "scopes" }) do
        dap.listeners.after[ev]["update_disassembly"] = function()
          dapui.elements.disassembly.render()
        end
      end

      for _, ev in ipairs({ "disconnect", "event_exited", "event_terminated" }) do
        dap.listeners.after[ev]["update_disassembly"] = function()
          Canvas.new():render_buffer(buf, config.element_mapping("disassembly"))
        end
      end
    end
  })

dapui.register_element("disassembly", {
  render = render,
  buffer = util.create_buffer("DAP Disassembly", {
    filetype = "dapui_disassembly",
    syntax = "asm",
  }),
  allow_without_session = false,
})
