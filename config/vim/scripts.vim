if did_filetype()	| finish | endif

if getline(1) =~ "// ==UserScript=="
  setf javascript
elseif getline(1) =~ "/* ==UserStyle=="
  setf css
elseif search('^\[\a\+\]$')
  setf dosini
endif
