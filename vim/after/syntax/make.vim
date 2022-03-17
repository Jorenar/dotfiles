
call utils#appendToSynRule("makeDefine", "fold")

syn clear makePreCondit
syn region makeIfElse transparent fold matchgroup=makePreCondit
      \ start = '\v^\s*ifn?(eq|def)>'
      \ start = '\v^\s*else(\s+ifn?(eq|def))?>'
      \ end = '\v\n\ze\s*else(\s+ifn?(eq|def))?>'
      \ end = '^\s*endif\>'

syn match makeTargetFold transparent fold '\v^.+\s*:\s*([^=]|$)\_.{-}\ze\n+([^\t]|$)'

syntax region makeMultilineVar keepend transparent fold
      \ start = "\v^\s*(export )?.*:\=.*\\$"
      \ end   = "\v%(\\\n)@<=.*[^\\]\_$"
