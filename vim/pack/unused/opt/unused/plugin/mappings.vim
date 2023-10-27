nnoremap [C  <Cmd>call utils#motion#jump_DiffAdd(-1)<CR>
nnoremap ]C  <Cmd>call utils#motion#jump_DiffAdd(1)<CR>

xnoremap # :<C-u>call utils#motion#VSetSearch('?')<CR>?<C-r>=@/<CR><CR>
xnoremap * :<C-u>call utils#motion#VSetSearch('/')<CR>/<C-r>=@/<CR><CR>
