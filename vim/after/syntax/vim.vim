call utils#appendToSynRule("vimOperParen", "region", "fold")

" https://vim.fandom.com/wiki/Syntax_folding_of_Vim_scripts#Syntax_definitions {{{1

syn cluster vimNoFold contains=vimComment,vimLineComment,vimCommentString,vimString,vimSynKeyRegion,vimSynRegPat,vimPatRegion,vimMapLhs,vimOperParen,@vimEmbeddedScript
syn cluster vimEmbeddedScript contains=vimMzSchemeRegion,vimTclRegion,vimPythonRegion,vimRubyRegion,vimPerlRegion

syn region vimFoldWhile
      \ start="\<wh\%[ile]\>"
      \ end="\<endw\%[hile]\>"
      \ transparent fold
      \ keepend extend
      \ containedin=ALLBUT,@vimNoFold
      \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'

syn region vimFoldFor
      \ start="\v<for>%(\s*\n\s*\\)?\s*.+%(\s*\n\s*\\\s*)?\s*<in>"
      \ end="\<endfo\%[r]\>"
      \ transparent fold
      \ keepend extend
      \ containedin=ALLBUT,@vimNoFold
      \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'

syn region vimFoldIfContainer
      \ start="\<if\>"
      \ end="\<en\%[dif]\>=\@!"
      \ transparent
      \ keepend extend
      \ containedin=ALLBUT,@vimNoFold
      \ contains=NONE
      \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'

syn region vimFoldIf
      \ start="\<if\>"
      \ end="^\s*\\\?\s*else\%[if]\>"ms=s-1,me=s-1
      \ fold transparent
      \ keepend
      \ contained containedin=vimFoldIfContainer
      \ nextgroup=vimFoldElseIf,vimFoldElse
      \ contains=TOP
      \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'

syn region vimFoldElseIf
      \ start="\<else\%[if]\>"
      \ end="^\s*\\\?\s*else\%[if]\>"ms=s-1,me=s-1
      \ fold transparent
      \ keepend
      \ contained containedin=vimFoldIfContainer
      \ nextgroup=vimFoldElseIf,vimFoldElse
      \ contains=TOP
      \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'

syn region vimFoldElse
      \ start="\<el\%[se]\>"
      \ end="\<en\%[dif]\>=\@!"
      \ fold transparent
      \ keepend
      \ contained containedin=vimFoldIfContainer
      \ contains=TOP
      \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'

syn region vimFoldTryContainer
      \ start="\<try\>"
      \ end="\<endt\%[ry]\>"
      \ transparent
      \ keepend extend
      \ containedin=ALLBUT,@vimNoFold
      \ contains=NONE
      \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'

syn region vimFoldTry
      \ start="\<try\>"
      \ end="^\s*\\\?\s*\(fina\%[lly]\|cat\%[ch]\)\>"ms=s-1,me=s-1
      \ fold transparent
      \ keepend
      \ contained containedin=vimFoldTryContainer
      \ nextgroup=vimFoldCatch,vimFoldFinally
      \ contains=TOP
      \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'

syn region vimFoldCatch
      \ start="\<cat\%[ch]\>"
      \ end="^\s*\\\?\s*\(cat\%[ch]\|fina\%[lly]\)\>"ms=s-1,me=s-1
      \ fold transparent
      \ keepend
      \ contained containedin=vimFoldTryContainer
      \ nextgroup=vimFoldCatch,vimFoldFinally
      \ contains=TOP
      \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'

syn region vimFoldFinally
      \ start="\<fina\%[lly]\>"
      \ end="\<endt\%[ry]\>"
      \ fold transparent
      \ keepend
      \ contained containedin=vimFoldTryContainer
      \ contains=TOP
      \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'
