let g:packs = get(g:, 'packs', {})

let g:packs.vim = #{
      \   conf: #{
      \     init: {
      \       'dir': $XDG_DATA_HOME.'/vim',
      \     },
      \   }
      \ }
let g:packs.vim_only = #{
      \   conf: #{
      \     init: {
      \       'dir': $XDG_DATA_HOME.'/vim',
      \     },
      \     pack: {
      \       'type': 'opt',
      \       '_ignore': has('nvim'),
      \     },
      \   }
      \ }

let g:packs.vim.list = {
      \   'ale': #{
      \     url: 'https://github.com/dense-analysis/ale.git',
      \   },
      \   'asyncrun.vim': #{
      \     url: 'https://github.com/skywind3000/asyncrun.vim.git',
      \   },
      \   'conflict-marker.vim': #{
      \     url: 'https://github.com/rhysd/conflict-marker.vim.git',
      \   },
      \   'diffconflicts': #{
      \     url: 'https://github.com/whiteinge/diffconflicts.git',
      \   },
      \   'exrc.vim': #{
      \     url: 'https://github.com/ii14/exrc.vim.git',
      \   },
      \   'fauxClip': #{
      \     url: 'https://github.com/Jorenar/fauxClip.git',
      \   },
      \   'gv.vim': #{
      \     url: 'https://github.com/junegunn/gv.vim.git',
      \   },
      \   'indent-sh.vim': #{
      \     url: 'https://github.com/Clavelito/indent-sh.vim.git',
      \   },
      \   'miniSnip': #{
      \     url: 'https://github.com/Jorenar/miniSnip.git',
      \   },
      \   'minpac': #{
      \     url: 'https://github.com/k-takata/minpac.git',
      \     conf: { 'type': 'opt' }
      \   },
      \   'NrrwRgn': #{
      \     url: 'https://github.com/chrisbra/NrrwRgn.git',
      \   },
      \   'tagbar': #{
      \     url: 'https://github.com/preservim/tagbar.git',
      \   },
      \   'textobj-word-column.vim': #{
      \     url: 'https://github.com/coderifous/textobj-word-column.vim.git',
      \   },
      \   'traces.vim': #{
      \     url: 'https://github.com/markonm/traces.vim.git',
      \   },
      \   'undotree': #{
      \     url: 'https://github.com/mbbill/undotree.git',
      \   },
      \   'vim-abolish': #{
      \     url: 'https://github.com/tpope/vim-abolish.git',
      \   },
      \   'vim-AdvancedSorters': #{
      \     url: 'https://github.com/inkarkat/vim-AdvancedSorters.git',
      \   },
      \   'vim-bookmarks': #{
      \     url: 'https://github.com/MattesGroeger/vim-bookmarks.git',
      \   },
      \   'vim-bufsurf': #{
      \     url: 'https://github.com/ton/vim-bufsurf.git',
      \   },
      \   'vim-commentary': #{
      \     url: 'https://github.com/tpope/vim-commentary.git',
      \   },
      \   'vim-emacsModeline': #{
      \     url: 'https://github.com/Jorenar/vim-emacsModeline.git',
      \   },
      \   'vim-eunuch': #{
      \     url: 'https://github.com/tpope/vim-eunuch.git',
      \   },
      \   'vim-fugitive': #{
      \     url: 'https://github.com/tpope/vim-fugitive.git',
      \   },
      \   'vim-fugitive-blame-ext': #{
      \     url: 'https://github.com/tommcdo/vim-fugitive-blame-ext.git',
      \   },
      \   'vim-ingo-library': #{
      \     url: 'https://github.com/inkarkat/vim-ingo-library.git',
      \   },
      \   'vim-mark': #{
      \     url: 'https://github.com/inkarkat/vim-mark.git',
      \   },
      \   'vim-obsession': #{
      \     url: 'https://github.com/tpope/vim-obsession.git',
      \   },
      \   'vim-prettyprint': #{
      \     url: 'https://github.com/thinca/vim-prettyprint.git',
      \   },
      \   'vim-qf': #{
      \     url: 'https://github.com/romainl/vim-qf.git',
      \   },
      \   'vim-repeat': #{
      \     url: 'https://github.com/tpope/vim-repeat.git',
      \   },
      \   'vim-signify': #{
      \     url: 'https://github.com/mhinz/vim-signify.git',
      \   },
      \   'vim-slime': #{
      \     url: 'https://github.com/jpalardy/vim-slime.git',
      \   },
      \   'vim-SQL-UPPER': #{
      \     url: 'https://github.com/Jorenar/vim-SQL-UPPER.git',
      \   },
      \   'vim-surround': #{
      \     url: 'https://github.com/tpope/vim-surround.git',
      \   },
      \   'vim-syntaxMarkerFold': #{
      \     url: 'https://github.com/Jorenar/vim-syntaxMarkerFold.git',
      \   },
      \   'vim-tex-syntax': #{
      \     url: 'https://github.com/gi1242/vim-tex-syntax.git',
      \   },
      \   'vim-visual-multi': #{
      \     url: 'https://github.com/mg979/vim-visual-multi.git',
      \   },
      \   'wrapwidth': #{
      \     url: 'https://github.com/rickhowe/wrapwidth.git',
      \   },
      \ }

let g:packs.vim_only.list = {
      \   'ctrlp.vim': #{
      \     url: 'https://github.com/ctrlpvim/ctrlp.vim.git',
      \   },
      \   'vim-lsp': #{
      \     url: 'https://github.com/prabirshrestha/vim-lsp.git',
      \   },
      \   'vim-lsp-ale': #{
      \     url: 'https://github.com/rhysd/vim-lsp-ale.git',
      \   },
      \   'vim-lsp-settings': #{
      \     url: 'https://github.com/mattn/vim-lsp-settings.git',
      \   },
      \ }

" vim: fdl=1
