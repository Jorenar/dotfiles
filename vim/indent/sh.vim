" Vim indent file
" Language:	     Shell Script
" Maintainer:    Nikolai Weibull <now@bitwi.se>
" Modified:      Edward L. Fox <edyfox@gmail.com>
" Last Modified: 2006-07-31 19:21:11

if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=GetShIndent()
setlocal indentkeys+==then,=do,=else,=elif,=esac,=fi,=fin,=fil,=done
setlocal indentkeys-=:,0#

if exists("*GetShIndent")
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

function GetShIndent()
    let lnum = prevnonblank(v:lnum - 1)
    if lnum == 0
        return 0
    endif

    " Add a 'shiftwidth' after if, while, else, case, until, for, function()
    " Skip if the line also contains the closure for the above

    let ind = indent(lnum)
    let line = getline(lnum)
    if line =~ '^\s*\(if\|then\|do\|else\|elif\|while\|until\|for\)\>'
                \ || (line =~ '^\s*case\>' && g:sh_indent_case_labels)
                \ || line =~ '^\s*\<\k\+\>\s*()\s*{'
                \ || line =~ '^\s*[^(]\+\s*)'
                \ || line =~ '^\s*{'
        if line !~ '\(esac\|fi\|done\)\>\s*$' && line !~ '}\s*$'
            let ind = ind + &sw
        endif
    endif

    if line =~ ';;'
        let ind = ind - &sw
    endif

    " Subtract a 'shiftwidth' on a then, do, else, esac, fi, done
    " Retain the indentation level if line matches fin (for find)
    let line = getline(v:lnum)
    if (line =~ '^\s*\(then\|do\|else\|elif\|fi\|done\)\>'
                \ || (line =~ '^\s*esac\>' && g:sh_indent_case_labels)
                \ || line =~ '^\s*}'
                \ )
                \ && line !~ '^\s*fi[ln]\>'
        let ind = ind - &sw
    endif

    return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
