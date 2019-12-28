syntax clear  cBlock
syntax match  cBlock1line /.\s*{.\{-}}/ transparent contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,cBlockImp
syntax region cBlockImp start=/\%(\/.*\)\@!.\n\?{/ start=/\/.*\n{/ end=/}/ end=/}\n\n/ end=/^}.*;\n\n/ transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket

syntax region cPreprocIf start="\#if" end="\#endif" transparent fold
