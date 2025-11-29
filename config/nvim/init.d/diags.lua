local ale_map = function(e)
  return {
    text     = e.message:gsub('\n', '\t'),
    detail   = vim.inspect(e),
    lnum     = e.lnum + 1,
    end_lnum = e.end_lnum + 1,
    col      = e.col + 1,
    end_col  = e.end_col,
    type = ({
        [vim.diagnostic.severity.ERROR] = 'E',
        [vim.diagnostic.severity.WARN]  = 'W',
        [vim.diagnostic.severity.INFO]  = 'I',
        [vim.diagnostic.severity.HINT]  = 'I',
      })[e.severity]
  }
end

local ale_handler = function(ns, bufnr, diagnostics, _)
  local name = vim.diagnostic.get_namespace(ns).name
  pcall(vim.fn['ale#other_source#ShowResults'],
    bufnr, name:gsub('^n?vim.lsp.', ''):gsub('%.%d+$', ''),
    vim.tbl_map(ale_map, diagnostics or {}))
end

vim.diagnostic.handlers["my/ale"] = {
  show = ale_handler,
  hide = ale_handler,
}


vim.diagnostic.config({
    signs = false,
    virtual_text = false,
  })

vim.cmd [[
  hi! link DiagnosticUnderlineError ALEError
  hi! link DiagnosticUnderlineHint  ALEInfo
  hi! link DiagnosticUnderlineInfo  ALEInfo
  hi! link DiagnosticUnderlineWarn  ALEWarning
]]
