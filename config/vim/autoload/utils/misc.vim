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

function! utils#misc#get_script_number(script_name)
  redir => scriptnames
  silent! scriptnames
  redir END

  for script in split(l:scriptnames, "\n")
    if l:script =~# a:script_name
      return str2nr(split(l:script, ':')[0])
    endif
  endfor
  return -1
endfunction
