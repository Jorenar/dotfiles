let g:tex_fold_enabled = 1
set foldmethod=syntax

let s:mathzones = [
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
