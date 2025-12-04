local fmt = function(diag)
  local src = vim.diagnostic.get_namespace(diag.namespace).name
  src = src:gsub('^n?vim.lsp.', ''):gsub('%.%d+$', '')
  src = (src == 'ale') and diag.source or src
  local msg = diag.message:gsub('\n', ' '):gsub('%s+', ' ')
  return string.format("[%s]: %s", src, msg)
end

vim.diagnostic.handlers['my/loclist'] = {
  show = function(_, bufnr)
    if vim.api.nvim_get_mode().mode ~= 'n' then return end
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == bufnr then
        vim.diagnostic.setloclist({
          open = false, format = fmt, winnr = win
        })
      end
    end
  end,
  hide = function(_, bufnr)
    if vim.bo[bufnr].buftype == "quickfix" then return end
    vim.diagnostic.handlers['my/loclist'].show(0, bufnr, {})
  end
}

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    local diags = vim.diagnostic.get(vim.api.nvim_get_current_buf(), {
      lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    })
    if vim.tbl_isempty(diags) then return end
    table.sort(diags, function(a, b)
      return (a.severity or 4) < (b.severity or 4)
    end)
    local msg, es = fmt(diags[1]), vim.v.echospace
    msg = (#msg < es) and (msg) or (msg:sub(1, es - 3) .. '...')
    vim.api.nvim_echo({ { msg } }, false, {})
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
