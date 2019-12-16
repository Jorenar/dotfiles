syn match cBlock2 /.\n{\_.\{-}}/ transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cCppParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell,cFunc,cppInline

"syn match cFunc /.(.*\n.*)\n{\_.\{-}}/ transparent fold contains=ALLBUT,cFunc,cBlock2,cppInline,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell

"syn match cppInline /.(.\{-})\s*{.\{-}}/ transparent fold contains=ALLBUT,cFunc,cBlock2,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell
