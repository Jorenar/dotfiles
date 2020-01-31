syn region jstCurlyBracketsFold start="{" end="}" transparent fold extend keepend

syn region jsCommentFold start="/\*" end="\*/" fold extend keepend

hi li jsCommentFold javaScriptComment
