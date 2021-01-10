setlocal cinoptions=g0,N-s,t0,(0,u0,U0,j1,ws,Ws,m1,J1,#0
setlocal complete-=i " Scanning included files when ^n is troublesome
setlocal foldmethod=syntax
setlocal path+=/usr/include/**

let c_curly_error  = 1
let c_space_errors = 1

let OmniCpp_GlobalScopeSearch   = 1
let OmniCpp_LocalSearchDecl     = 1
let OmniCpp_MayCompleteArrow    = 0
let OmniCpp_MayCompleteDot      = 0
let OmniCpp_ShowAccess          = 1
let OmniCpp_ShowPrototypeInAbbr = 1

let b:ale_linters_ignore = [ "clangtidy" ]
