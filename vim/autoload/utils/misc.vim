function! utils#misc#VisSort() range abort " sorts based on visual-block selected portion of the lines
  if visualmode() != "\<C-v>"
    exec "sil! ".a:firstline.",".a:lastline."sort i"
    return
  endif
  let [ firstline, lastline ] = [ line("'<"), line("'>") ]
  let old_a  = @a
  silent normal! gv"ay
  '<,'>s/^/@@@/
  silent! keepjumps normal! '<0"aP
  silent! keepj '<,'>sort i
  execute "sil! keepj ".firstline.",".lastline.'s/^.\{-}@@@//'
  let @a = old_a
endfun

function! utils#misc#scroll_cursor_popup(count) abort
  let srow = screenrow()
  let scol = screencol()

  for r in range(srow-2, srow+2)
    for c in range(scol-2, scol+2)
      let winid = popup_locate(r, c)
      if winid != 0
        let pp = popup_getpos(winid)
        call popup_setoptions(winid, {
              \   'firstline' : pp.firstline + a:count
              \ })
        return 1
      endif
    endfor
  endfor

  return 0
endfunction

function! utils#misc#ColorDemo() abort  " preview of Vim 256 colors
  20 vnew
  setlocal nonumber buftype=nofile bufhidden=hide noswapfile statusline=\ Color\ demo
  let num = 255
  while num >= 0
    execute 'hi col_'.num.' ctermbg='.num.' ctermfg='.num
    execute 'syn match col_'.num.' "='.printf("%3d", num).'" containedIn=ALL'
    call append(0, ' '.printf("%3d", num).'  ='.printf("%3d", num))
    let num -= 1
  endwhile
endfunction
