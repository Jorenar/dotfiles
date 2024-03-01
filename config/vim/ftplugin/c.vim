setlocal cinoptions=g0,N-s,t0,(0,u0,U0,J1,j1,ws,Ws,m1,#0,:0,L-1
setlocal complete-=i " Scanning included files when ^n is troublesome
setlocal foldmethod=syntax
setlocal path+=/usr/include/**

let c_no_if0       = 1
let c_curly_error  = 1
let c_space_errors = 1

SetFormatProg "uncrustify -l C -c " . $XDG_CONFIG_HOME."/uncrustify/langs/c.cfg"

compiler gcc

let b:ale_c_clangcheck_options =
      \ ' --extra-arg=-Xclang --extra-arg=-analyzer-output=text --extra-arg=-fno-color-diagnostics'
let b:ale_c_clangtidy_extra_options =
      \ '--checks=-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling'
