nnoremap <Leader>t :Tagbar<CR>

let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_ctags_options = [ findfile('ctags.cnf', &rtp) ]

hi! link TagbarNestedKind Comment
hi! link TagbarType Comment


let g:tagbar_type_groovy = #{
      \   kinds: [
      \     'c:classes',
      \     'e:enums',
      \     'f:functions',
      \     'i:interfaces',
      \     'p:package:1',
      \     't:traits',
      \   ]
      \ }

augroup TagbarProjects
  autocmd User *.gradle let b:tagbar_type = #{
        \   kinds: [
        \     'm:methods',
        \     't:tasks',
        \   ]
        \ }
augroup END


let g:tagbar_type_vb = #{
      \   kinds: [
      \     'T:types',
      \     's:subroutines',
      \     'f:functions',
      \     'E:events',
      \     'v:variables',
      \     'c:constants',
      \     'p:properties',
      \     'e:enum',
      \   ]
      \ }
