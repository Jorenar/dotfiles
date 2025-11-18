local packages = {
  -- LSP {{{1
  "arduino-language-server",
  "asm-lsp",
  "autotools-language-server",
  "bash-language-server",
  "deno",
  "digestif",
  "gopls",
  "harper-ls",
  "jedi-language-server",
  "lua-language-server",
  "m68k-lsp-server",
  "openscad-lsp",
  "sonarlint-language-server",
  "sqls",
  "texlab",
  "vim-language-server",
  "yaml-language-server",

  -- DAP {{{1
  "bash-debug-adapter",
  "cpptools",
  "debugpy",
  "php-debug-adapter",

  -- fmt {{{1
  "autopep8",
  "shfmt",

  -- lint {{{1
  "semgrep",
  "shellcheck",
  "vint",
  -- "ast-grep",
  -- "vale",

  -- {{{1
  -- }}}1
}


vim.api.nvim_create_user_command("MasonEnsure", function()
  vim.cmd("Mason")
  local registry = require("mason-registry")
  for _, package in ipairs(packages) do
    if not registry.is_installed(package) then
      registry.get_package(package):install()
    end
  end
end, { nargs = 0 })
