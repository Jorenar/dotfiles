set cinoptions+=(1s,g2,h2,N-2,t0
set complete-=i " Scanning included files when ^n is troublesome
set foldmethod=syntax
set path+=/usr/include/**
set tags+=$XDG_DATA_HOME/tags/c

let OmniCpp_GlobalScopeSearch   = 1
let OmniCpp_LocalSearchDecl     = 1
let OmniCpp_MayCompleteArrow    = 0
let OmniCpp_MayCompleteDot      = 0
let OmniCpp_ShowAccess          = 1
let OmniCpp_ShowPrototypeInAbbr = 1
