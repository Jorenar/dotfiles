syntax clear  cBlock

syntax region cBlockImp start=/\%(\/.*\)\@!.\n\?{/ start=/\/.*\n{/ end=/}/ transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket

syntax region cPreprocIf start="\#if" end="\#endif" transparent fold
