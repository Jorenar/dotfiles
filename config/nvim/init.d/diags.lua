local fmt = function(diag)
  local src = vim.diagnostic.get_namespace(diag.namespace).name
  src = src:gsub('^n?vim.lsp.', ''):gsub('%.%d+$', '')
  src = (src == 'ale') and diag.source or src
  return string.format("[%s]: %s", src, diag.message:match("([^\n]*)"))
end

vim.diagnostic.handlers['my/loclist'] = (function(h)
  return { show = h, hide = h }
end)(function()
  vim.diagnostic.setloclist({ open = false, format = fmt })
end)

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    local diags = vim.diagnostic.get(vim.api.nvim_get_current_buf(), {
      lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    })
    if vim.tbl_isempty(diags) then
      vim.api.nvim_echo({ { '' } }, false, {})
      return
    end
    table.sort(diags, function(a, b)
      return (a.severity or 4) < (b.severity or 4)
    end)
    vim.api.nvim_echo({ { fmt(diags[1]) } }, false, {})
  end
})

vim.diagnostic.config({ signs = false, virtual_text = false })

vim.keymap.set('n', 'LD', function()
  vim.diagnostic.open_float({ border = 'single' })
end, { noremap = true })

vim.cmd [[
  hi! DiagnosticInfo NONE ctermfg=39
  hi! link DiagnosticUnderlineError ErrorMsg
  hi! link DiagnosticUnderlineHint  ALEInfo
  hi! link DiagnosticUnderlineInfo  ALEInfo
  hi! link DiagnosticUnderlineWarn  WarningMsg
]]
