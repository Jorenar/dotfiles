setlocal foldmethod=syntax

let g:ale_groovy_npmgroovylint_options = '--no-insight'
      \ . (executable('java') ? ' -j '.exepath('java') : '')
autocmd VimLeavePre * sil! !npm-groovy-lint --killserver &
