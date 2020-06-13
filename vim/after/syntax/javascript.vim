syn region jsCurlyBracketsFold start="{" end="}" transparent fold containedin=ALLBUT,javaScriptFunctionFold

syn region jsCommentFold start="/\*" end="\*/" fold extend keepend

hi li jsCommentFold javaScriptComment
