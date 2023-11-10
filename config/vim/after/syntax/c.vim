if &ft !~# '\v<(c|cpp)>' | finish | endif " vim: fdl=1

call utils#syntax#rule_append("cParen", "fold")

syntax region cCaseFold transparent fold
      \ start = "\v\z(<case>\s+\S+\s*)@<=:%(\s|$)"
      \ start = "\v%(<default>\s*)@<=:"
      \ end   = "\v\ze\/\/\s\z1"
      \ end   = "\v\n?\ze\n*\s*<%(case|default)>(\s+\S+)?\s*:"
      \ end   = "\v\n?\ze\n*%(\s*//.*\n\s*)+<%(case|default)>%(\s+\S+)?\s*:"
      \ end   = "\v\n?\ze\n+\s*/\*.*\*/\n?\s*<%(case|default)>%(\s+\S+)?\s*:"
      \ end   = "\n\ze\n*.*}"

syntax region cMacroFold keepend transparent fold
      \ start="#define .*\\$" end="\v%(\\\n)@<=.*[^\\]\_$"

syntax region cStringFold transparent fold
      \ start = "\v%(%(const\s)?\s*char)@<=\s+.*\\$"
      \ end   = ";"

syntax region cLongComment fold
      \ start="^\s*//.*\n\ze\%(\s*//.*\n\)\{3,}" end="^\%(//\)\@!"
hi link cLongComment cCommentL

syn region cPragmaRegion fold transparent keepend extend
      \ start='#pragma region' end='#pragma endregion'

syntax region cPreProcFold transparent fold
      \ start = "\v#if%(ndef (.+_H.*_?)\n#\s*define \1)@!"
      \ skip  = "\v\#endif //\s*(.+_H.*_?)"
      \ end   = "#endif"

syntax region doxygenGroupFold matchgroup=Comment transparent fold
      \ start = '\(///.*\n\)*///.*@{.*'
      \ end   = '///.*@}.*'
