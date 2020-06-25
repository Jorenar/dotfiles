set cinoptions=g0,N-s,t0,(0,u0,U0,j1,ws,Ws,J1,#0
set complete-=i " Scanning included files when ^n is troublesome
set foldmethod=syntax
set path+=/usr/include/**

if !get(g:, "enable_lsp", 1)
  set tags+=$XDG_DATA_HOME/tags/c

  let OmniCpp_GlobalScopeSearch   = 1
  let OmniCpp_LocalSearchDecl     = 1
  let OmniCpp_MayCompleteArrow    = 0
  let OmniCpp_MayCompleteDot      = 0
  let OmniCpp_ShowAccess          = 1
  let OmniCpp_ShowPrototypeInAbbr = 1
endif
