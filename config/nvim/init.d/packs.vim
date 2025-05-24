let g:packs = get(g:, 'packs', {})

let g:packs.neovim = #{
      \   conf: #{
      \     init: {
      \       'dir': stdpath('data').'/site',
      \     },
      \   }
      \ }

let g:packs.neovim.list = {
      \   'cscope_maps.nvim': #{
      \     url: 'https://github.com/dhananjaylatkar/cscope_maps.nvim.git',
      \   },
      \   'nvim-dap': #{
      \     url: 'https://github.com/mfussenegger/nvim-dap.git',
      \   },
      \   'nvim-dap-disasm': #{
      \     url: 'https://github.com/Jorenar/nvim-dap-disasm.git',
      \   },
      \   'nvim-dap-ui': #{
      \     url: 'https://github.com/rcarriga/nvim-dap-ui.git',
      \   },
      \   'flatten.nvim': #{
      \     url: 'https://github.com/willothy/flatten.nvim.git',
      \   },
      \   'fzf-lua': #{
      \     url: 'https://github.com/ibhagwan/fzf-lua.git',
      \   },
      \   'goto-preview': #{
      \     url: 'https://github.com/rmagatti/goto-preview.git',
      \   },
      \   'mason.nvim': #{
      \     url: 'https://github.com/williamboman/mason.nvim.git',
      \   },
      \   'mason-nvim-dap.nvim': #{
      \     url: 'https://github.com/jay-babu/mason-nvim-dap.nvim.git',
      \   },
      \   'nvim-nio': #{
      \     url: 'https://github.com/nvim-neotest/nvim-nio.git',
      \   },
      \   'nvim-lspconfig': #{
      \     url: 'https://github.com/neovim/nvim-lspconfig.git',
      \   },
      \   'nvim-treesitter': #{
      \     url: 'https://github.com/nvim-treesitter/nvim-treesitter.git',
      \   },
      \   'nvim-treesitter-context': #{
      \     url: 'https://github.com/nvim-treesitter/nvim-treesitter-context.git',
      \   },
      \   'plenary.nvim': #{
      \     url: 'https://github.com/nvim-lua/plenary.nvim.git',
      \   },
      \   'sonarlint.nvim': #{
      \     url: 'https://gitlab.com/schrieveslaach/sonarlint.nvim.git',
      \   },
      \   'sqls.nvim': #{
      \     url: 'https://github.com/nanotee/sqls.nvim.git',
      \   },
      \   'vim-suda': #{
      \     url: 'https://github.com/lambdalisue/vim-suda.git',
      \   },
      \   'vimterm.nvim': #{
      \     url: 'https://github.com/VioletJewel/vimterm.nvim.git',
      \   },
      \ }

" vim: fdl=1
