function! GetBashFold()
    let line = getline(v:lnum)

    " End of if statement
    if line =~? '\v^\s*fi\s*$'
        return 's1'
    endif
    " Start of if statement
    if line =~? '\v^\s*if.*(;\s*then)?$'
        return 'a1'
    endif

    " End of while/for statement
    if line =~? '\v^\s*done\s*$'
        return 's1'
    endif
    " Start of while/for statement
    if line =~? '\v^\s*(while|for).*(;\s*do)?$'
        return 'a1'
    endif

    " End of case statement
    if line =~? '\v^\s*esac\s*$'
        return 's1'
    endif
    " Start of case statement
    if line =~? '\v^\s*case.*(\s*in)$'
        return 'a1'
    endif

    " End of function statement
    if line =~? '\v^\s*\}$'
        return 's1'
    endif
    " Start of function statement
    if line =~? '\v^\s*(function\s+)?\S+\(\) \{'
        return 'a1'
    endif

    " Default
    return '='

endfunction

augroup sh
    au BufReadPre *.sh setlocal foldmethod=expr
    au BufWinEnter *.sh if &fdm == 'expr' | setlocal foldexpr=GetBashFold() | endif
augroup END
