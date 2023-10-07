let g:sh_fold_enabled = 7
setlocal foldmethod=syntax

setlocal iskeyword+=-

let g:is_posix = 1

setlocal omnifunc=bashcomplete#omnicomplete

if !get(g:, "sh_env_vars_cached", 0)
  let s:dict_compl = expand($XDG_CACHE_HOME."/vim/dict_compl")
  call mkdir(s:dict_compl, "p")
  call system("env | cut -d= -f1 > ".s:dict_compl."/env_variables")
  let &complete .= ",k".s:dict_compl."/env_variables"
  let g:sh_env_vars_cached = 1
endif
