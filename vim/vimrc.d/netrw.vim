let g:netrw_banner        = 0         " do not display info on the top of window
let g:netrw_liststyle     = 3         " tree-view
let g:netrw_sort_sequence = '[\/]$,*' " sort is affecting only: directories on the top, files below
let g:netrw_browse_split  = 4         " use the previous window to open file
let g:netrw_dirhistmax    = 0         " disable history
let g:netrw_winsize       = -28       " window size

augroup netrw_autocmd
  autocmd!
  autocmd filetype netrw silent! unmap <buffer> <F1>
  autocmd filetype netrw silent! unmap <buffer> <C-l>
  autocmd filetype netrw setlocal statusline=%f

  autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" | q | endif
augroup END

" Toggle Vexplore with Ctrl-O
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
    let expl_win_num = bufwinnr(t:expl_buf_num)
    let cur_win_num = winnr()

    if expl_win_num != -1
      while expl_win_num != cur_win_num
        exec "wincmd w"
        let cur_win_num = winnr()
      endwhile

      close
    endif

    unlet t:expl_buf_num
  else
    Vexplore
    let t:expl_buf_num = bufnr("%")
  endif
endfunction

command ToggleVExplorer call ToggleVExplorer()

function! Drawer() abort
  let nr = bufnr('%')
  ToggleVExplorer

  if exists(":Tagbar")
    let vert_old = g:tagbar_vertical
    let g:tagbar_vertical = 30
    Tagbar
    let g:tagbar_vertical = vert_old
  endif

  execute bufwinnr(nr)."wincmd w"
endfunction

nnoremap <silent> <C-e> :call Drawer()<CR>

" vim: fen
