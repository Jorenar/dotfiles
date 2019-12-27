syntax clear  cBlock
syntax region cBlockImp start="\(/.*\)\?.\n\?{" end="};\?\(\n\n\)\?" transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell
syntax match  cFuncOneLine /.(.\{-})\s*{.\{-}}$/ transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell,cBlockImp
