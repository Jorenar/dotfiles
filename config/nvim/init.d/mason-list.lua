local packages = {
  "arduino-language-server",
  "asm-lsp",
  "ast-grep",
  "autopep8",
  "autotools-language-server",
  "bash-debug-adapter",
  "bash-language-server",
  "cpptools",
  "css-lsp",
  "debugpy",
  "deno",
  "digestif",
  "gopls",
  "harper-ls",
  "jedi-language-server",
  "json-lsp",
  "lua-language-server",
  "m68k-lsp-server",
  "npm-groovy-lint",
  "openscad-lsp",
  "php-debug-adapter",
  "semgrep",
  "shellcheck",
  "shfmt",
  "sonarlint-language-server",
  "sqls",
  "texlab",
  "tree-sitter-cli",
  "vale",
  "vim-language-server",
  "vint",
  "yaml-language-server",
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
