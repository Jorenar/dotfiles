require("nvim-treesitter.configs").setup({
  parser_install_dir = vim.fn.stdpath("data") .. "/site"
})

-- context {{{1

local context = require("treesitter-context")

context.setup({
  enable = false,
  multiwindow = true,
  separator = '·',
})

for _, g in ipairs({
  "TreesitterContext",
  "TreesitterContextLineNumber",
  "TreesitterContextSeparator",
  "TreesitterContextBottom",
}) do
  vim.api.nvim_set_hl(0, g, { link = 'Comment' })
end

vim.keymap.set("n", "<Leader>t", context.toggle, { noremap = true })
