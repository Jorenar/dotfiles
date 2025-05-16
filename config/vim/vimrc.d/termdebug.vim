let g:termdebug_config = #{
      \   wide: 1,
      \   disasm_window: v:true,
      \   disasm_window_height: 15,
      \   variables_window: v:false,
      \   map_K: v:false,
      \   map_minus: v:false,
      \   map_plus: v:false,
      \ }


function! s:disasm() abort
  if bufname() !=# 'Termdebug-asm-listing'
    return
  endif

  setlocal filetype= syntax=asm
  setlocal tabstop=8 nolist
  setlocal textwidth=0 colorcolumn=
  %s/\d>:\zs \+/\t/e
endfunction

autocmd User TermdebugStartPre
      \ autocmd FileType asm call <SID>disasm()

function! s:set_keymaps() abort
  let l:mappings = [
        \   [ 'n', 'd',  ':<C-u>' ],
        \   [ 'n', 'd:', ':<C-u>' ],
        \   [ 'n', 'db', '<Cmd>Break<CR>' ],
        \   [ 'n', 'dr', '<Cmd>Until<CR>' ],
        \   [ 'n', 'dk', '<Cmd>Evaluate<CR>' ],
        \   [ 'x', 'dk', '<Cmd>Evaluate<CR>' ],
        \ ]

  for m in l:mappings
    exec m[0].'map <silent> <Leader>'.m[1].' '.m[2]
  endfor
endfunction

autocmd User TermdebugStartPre call <SID>set_keymaps()
