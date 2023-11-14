" jumpfile
" Source: https://gitlab.com/egzvor/vimfiles/-/blob/main/plugin/jumpfile.vim

if exists('g:loaded_jumpfile') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

function! JumpFileComputePrev()
  let [jump_list, pos] = getjumplist()
  let previous_list = jump_list
        \ ->map({idx, val -> [idx, val]})[:pos]
        \ ->reverse()
        \ ->filter({idx, pos_b -> pos_b[1].bufnr != bufnr()})
  return  previous_list != []
        \ ? pos - previous_list[0][0]
        \ : 0
endfunction

function! JumpFileComputeNext()
  let [jump_list, pos] = getjumplist()
  let next_list = jump_list
        \ ->map({idx, val -> [idx, val]})[pos:]
        \ ->filter({idx, pos_b -> pos_b[1].bufnr != bufnr()})
  return  next_list != []
        \ ? next_list[0][0] - pos
        \ : 0
endfunction


nnoremap go <Cmd>exec 'normal! ' . JumpFileComputePrev() . "\<c-o>"<CR>
nnoremap gi <Cmd>exec 'normal! ' . JumpFileComputeNext() . "\<c-i>"<CR>


let g:loaded_jumpfile = 1
let &cpo = s:cpo_save | unlet s:cpo_save
