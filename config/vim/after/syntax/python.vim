syn keyword pythonStatement  class def
syn match pythonFunction '\h\w*\ze\s*(' containedin=pythonFold
syn region  pythonFold  fold transparent
      \ start = '\(^\z(\s*\)\v%(def|class|if|elif|else|for|while|try|except|finally|with)>)@<='
      \ end   = '\v\ze%(\s*\n)+%(\z1\s)@!.'

syn clear pythonFStringFieldSkip
syn region pythonCurlyBrace start='{' end='}' fold transparent
syn region pythonSquareBrace start='\[' end='\]' fold transparent

call utils#syntax#rule_append("pythonString", "fold")
