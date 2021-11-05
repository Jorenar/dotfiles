let g:sh_fold_enabled = 5
setlocal foldmethod=syntax

setlocal iskeyword+=-

let g:is_posix = 1

let s:dict_compl = expand("$XDG_CACHE_HOME/vim/dict_compl")
call mkdir(s:dict_compl, "p")
call system("env | cut -f 1 -d= > ".s:dict_compl."/env_variables")
let &complete .= ",k".s:dict_compl."/env_variables"
