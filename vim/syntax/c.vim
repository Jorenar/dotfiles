syntax clear  cBlock
syntax match  cFuncOneLine /.(.\{-})\s*{.\{-}}$/ transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell,cBlockImp
syntax region cBlockImp start="\(/.*\)\?.\n\?{" end="};\?\(\n\n\)\?" transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell
syntax region cPreprocIf start="\#if" end="\#endif" transparent fold
