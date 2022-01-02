syn keyword pythonStatement	class def
syn match pythonFunction "\h\w*" containedin=pythonFold
syn region  pythonFold  fold transparent
      \ start = "\(^\z(\s*\)\v%(def|class)>.*\n)@<="
      \ start = "\(^\z(\s*\)\v%(if|elif|else|for|while|try|except|finally)>)@<="
      \ end   = "\v\ze%(\s*\n)+%(\z1\s)@!."
