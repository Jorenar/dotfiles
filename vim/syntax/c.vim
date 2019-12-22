syn match cBlock2 /.\n{\_.\{-}}/ transparent fold

syn match cFunc /.(.*\n.*)\n{\_.\{-}}/ transparent fold contains=ALLBUT,cFunc,cBlock2,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell
