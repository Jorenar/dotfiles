let w:QfQoL_isLocList = getwininfo(win_getid())[0]['loclist']

if w:QfQoL_isLocList
  noremap <buffer> g- :lolder<CR>
  noremap <buffer> g+ :lnewer<CR>
else
  noremap <buffer> g- :colder<CR>
  noremap <buffer> g+ :cnewer<CR>
endif

command! -buffer -nargs=*  Sort
      \ call QfQoL#sort("<args>")
