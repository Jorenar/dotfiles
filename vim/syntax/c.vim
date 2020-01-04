syntax clear  cBlock
syntax match  cBlock1line /{.\{-}}/ transparent contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,cBlockImp

if get(g:, "fold_new_line", 1)
    syntax region cBlockImp start=/\%(\/.*\)\@!.\n\?{/ start=/\/.*\n{/ end=/}/ end=/}\n\n/ end=/^}.*;\n\n/ transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket
else
    syntax region cBlockImp start=/\%(\/.*\)\@!.\n\?{/ start=/\/.*\n{/ end=/}/ transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket
endif

syntax region cPreprocIf start="\#if" end="\#endif" transparent fold
