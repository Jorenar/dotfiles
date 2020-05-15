runtime ftplugin/plaintex.vim

let s:mathzones = [
      \ "align",
      \ "gather",
      \ "itemize",
      \ ]

function s:NewMathZones()
  for mz in s:mathzones
    call TexNewMathZone("A", mz, 1)
  endfor
endfunction

augroup TEXNEWMATHZONE
  au!
  autocmd VimEnter * call s:NewMathZones()
augroup END
