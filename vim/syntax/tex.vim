if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match  texComment "%.*$"

syntax region texPreamble transparent fold contains=texStyle,@texPreambleMatchGroup
      \ start = '\zs\\documentclass\>'
      \ end   = '\ze\\begin{document}'

syntax region texBeginEndFold transparent fold containedin=texBeginEnd
      \ start = "\v\\<begin>"
      \ end   = "\v\\<end>"
      "\ start = "\v\\<begin>\{(document)@!"

syn region texCommentFold transparent fold
      \ start = "\v(\s*\%.*\n)@<!\s*\%"
      \ skip  = "^\s*%"
      \ end   = '^\ze\s*[^%]\?'

syn region texPartZone           start='\\part\>'                   end='\ze\s*\\\%(part\>\|end\s*{\s*document\s*}\)'                                                         transparent fold
syn region texChapterZone        start='\\chapter\>'                end='\ze\s*\\\%(chapter\>\|part\>\|end\s*{\s*document\s*}\)'                                              transparent fold
syn region texSectionZone        start='\\section\>'                end='\ze\s*\\\%(section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'                                   transparent fold
syn region texSubSectionZone     start='\\subsection\>'             end='\ze\s*\\\%(\%(sub\)\=section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'                         transparent fold
syn region texSubSubSectionZone  start='\\subsubsection\>'          end='\ze\s*\\\%(\%(sub\)\{,2}section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'                      transparent fold
syn region texParaZone           start='\\paragraph\>'              end='\ze\s*\\\%(paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'             transparent fold
syn region texSubParaZone        start='\\subparagraph\>'           end='\ze\s*\\\%(\%(sub\)\=paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'   transparent fold
syn region texTitle              start='\\\%(author\|title\)\>\s*{' end='}'                                                                                                   transparent fold

hi def link texComment  Comment

let b:current_syntax = "tex"

let &cpo = s:cpo_save
unlet s:cpo_save
