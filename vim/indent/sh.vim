" Vim indent file
" Language:         Shell Script
" Maintainer:       Clavelito <maromomo@hotmail.com>
" Id:               $Date: 2016-01-12 14:34:51+09 $
"                   $Revision: 4.0 $
"
" Description:      Set the following line if you do not want automatic
"                   indentation in the case labels.
"                   let g:sh_indent_case_labels = 0


if exists("b:did_indent") || !exists("g:syntax_on")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetShIndent()
setlocal indentkeys+=0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done,0=)
setlocal indentkeys+=0=fin,0=fil,0=fip,0=fir,0=fix
setlocal indentkeys-=:,0#

if exists("*GetShIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

let s:back_quote = 'shCommandSub'
let s:sh_cmd_sub_region = 'shCommandSub\|shCmdSubRegion'
let s:sh_comment = 'shComment'
let s:d_or_s_quote = 'DoubleQuote\|SingleQuote'
let s:sh_quote = 'shQuote'
let s:sh_here_doc = 'shHereDoc'
let s:sh_here_doc_eof = 'shHereDoc\d\d'

if !exists("g:sh_indent_case_labels")
  let g:sh_indent_case_labels = 1
endif

function GetShIndent()
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif

  if exists("b:sh_indent_tabstop")
    let &tabstop = b:sh_indent_tabstop
    unlet b:sh_indent_tabstop
  endif

  let cline = getline(v:lnum)
  let line = getline(lnum)

  if cline =~ '^#'
    return 0
  endif

  for cid in synstack(lnum, strlen(line))
    if synIDattr(cid, 'name') =~ s:sh_here_doc. '$'
      let lnum = s:SkipItemsLines(v:lnum, s:sh_here_doc)
      let ind = s:InsideHereDocIndent(lnum, cline)
      return ind
    endif
  endfor
  let cname = ""
  for cid in reverse(synstack(lnum, strlen(line)))
    let cname = synIDattr(cid, 'name')
    if cname =~ s:sh_quote
      continue
    elseif cname =~ s:sh_cmd_sub_region
      break
    elseif cname =~ s:d_or_s_quote
      return indent(v:lnum)
    endif
  endfor

  let [line, lnum] = s:SkipCommentLine(line, lnum, 0)
  let eind = 0
  for lid in reverse(synstack(lnum, 1))
    let lname = synIDattr(lid, 'name')
    if lname =~ s:sh_cmd_sub_region && cname =~ s:sh_cmd_sub_region
      break
    elseif lname =~ s:sh_here_doc_eof
      let lnum = s:SkipItemsLines(lnum, s:sh_here_doc)
      let line = getline(lnum)
      break
    elseif lname =~ s:d_or_s_quote. '\|'. s:sh_quote
      let eind = s:BackQuoteIndent(lnum, 0)
      let line = s:HideQuoteStr(line, lnum, 1)
      let lnum = s:SkipItemsLines(lnum, s:d_or_s_quote. '\|'. s:sh_quote)
      let line = s:HideQuoteStr(getline(lnum), lnum, 0). line
      break
    endif
  endfor

  let ind = indent(lnum) + eind
  let ind = s:BackQuoteIndent(lnum, ind)
  let [pline, pnum] = s:SkipCommentLine(line, lnum, 1)
  let [pline, ind] = s:MorePrevLineIndent(pline, pnum, line, ind)
  let ind = s:InsideCaseLabelIndent(pline, line, ind)
  let line = s:HideCaseLabelLine(line, pline)
  let ind = s:PrevLineIndent(line, lnum, pline, ind)
  let ind = s:CurrentLineIndent(line, cline, ind)

  return ind
endfunction

function s:MorePrevLineIndent(pline, pnum, line, ind)
  let ind = a:ind
  let pline = a:pline
  if a:pline !~ '\\$' && a:line =~ '\\$'
        \ && a:line !~ '\%(^\s*\|[^<]\)<<-\=\s*\\$'
        \ && a:pline !~# '^\s*case\>\|[|&`()]\s*case\>'
        \ && a:pline !~ ';;\s*$'
    let ind = ind + &sw
  elseif a:pline =~ '\\$' && a:line !~ '\\$'
    let pline = s:JoinContinueLine(a:pline, a:pnum)
    if pline !~# '^\s*case\>\|[|&`()]\s*case\>'
          \ && pline !~ ';;\s*$'
          \ || a:line =~ ';;\s*$'
      let ind = ind - &sw
    endif
  endif

  return [pline, ind]
endfunction

function s:InsideCaseLabelIndent(pline, line, ind)
  let ind = a:ind
  if a:line =~# '^\s*esac\>\s*;;\s*$' && a:pline =~ ';;\s*$'
    let ind = ind - &sw
  elseif a:line =~ ';;\s*$'
        \ && (a:pline !~# '^\s*case\>\|[|&`()]\s*case\>'
        \ && a:pline !~ ';;\s*$'
        \ || a:pline =~# '\s*case\>.*;;\s*esac\>')
    let ind = ind - &sw
  elseif a:line =~ '^\s*[^(].\{-})' && a:line !~ ';;\s*$'
        \ && a:line !~# '^\s*case\>'
        \ && (a:pline =~# '^\s*case\>\|[|&`()]\s*case\>'
        \ || a:pline =~ ';;\s*$')
        \ && a:pline !~# '\s*case\>.*;;\s*esac\>'
    let ind = ind + &sw
  endif

  return ind
endfunction

function s:PrevLineIndent(line, lnum, pline, ind)
  let ind = a:ind
  if a:line =~# '^\s*\%(\h\w*\s*(\s*)\s*\)\=[{(]\s*$'
        \. '\|^\s*function\s\+\S\+\%(\s\+{\|\s*(\s*)\s*[{(]\)\s*$'
        \. '\|\%(;\|&&\|||\)\s*[{(]\s*$'
    let ind = ind + &sw
  else
    let line = s:HideAnyItemLine(a:line, a:lnum)
    if line =~ '\\\@<!\%(\\\\\)*[({]'
      let ind = ind + &sw * (len(split(line, '\\\@<!\%(\\\\\)*[({]', 1)) - 1)
    endif
    let ind = s:CloseParenIndent(a:line, a:pline, line, ind)
    let ind = s:CloseBraceIndnnt(a:line, line, ind)
    if line =~ '\\\@<!\%(\\\\\)*[|&`(]'
      for line in split(line, '\\\@<!\%(\\\\\)*[|&`(]')
        let ind = s:PrevLineIndent2(line, ind)
      endfor
    else
      let ind = s:PrevLineIndent2(line, ind)
    endif
  endif

  return ind
endfunction

function s:PrevLineIndent2(line, ind)
  let ind = a:ind
  if a:line =~# '^\s*\%(if\|then\|else\|elif\)\>'
        \ && a:line !~# ';\s*\<fi\>'
        \ || a:line =~# '^\s*\%(do\|while\|until\|for\)\>'
        \ && a:line !~# ';\s*\<done\>'
    let ind = ind + &sw
  elseif a:line =~# '^\s*case\>'
        \ && a:line !~# ';;\s*\<esac\>' && g:sh_indent_case_labels
    let ind = ind + &sw / g:sh_indent_case_labels
  endif

  return ind
endfunction

function s:CurrentLineIndent(line, cline, ind)
  let ind = a:ind
  if a:cline =~# '^\s*\%(then\|do\|else\|elif\|fi\|done\)\>'
        \ || a:cline =~ '^\s*[})]'
    let ind = ind - &sw
  elseif a:cline =~# '^\s*esac\>' && g:sh_indent_case_labels
    let ind = ind - &sw / g:sh_indent_case_labels
  endif
  if a:cline =~# '^\s*esac\>' && a:line !~ ';;\s*$'
    let ind = ind - &sw
  endif

  return ind
endfunction

function s:CloseParenIndent(line, pline, nline, ind)
  let ind = a:ind
  if a:nline =~ '\\\@<!\%(\\\\\)*)'
        \ && a:nline !~# '^\s*case\>'
        \ && a:pline !~# '^\s*case\>\|[|&`()]\s*case\>'
        \ && a:pline !~ ';;\s*$'
    if a:line =~ '^\s*)'
      let ind = ind + &sw
    endif
    let ind = ind - &sw * (len(split(a:nline, '\\\@<!\%(\\\\\)*)', 1)) - 1)
  endif

  return ind
endfunction

function s:CloseBraceIndnnt(line, nline, ind)
  let ind = a:ind
  if a:nline =~ '\\\@<!\%(\\\\\)*}'
    if a:line =~ '^\s*}'
      let ind = ind + &sw
    endif
    let ind = ind - &sw * (len(split(a:nline, '\\\@<!\%(\\\\\)*}', 1)) - 1)
  endif

  return ind
endfunction

function s:SkipCommentLine(line, lnum, prev)
  let line = a:line
  let lnum = a:lnum
  if a:prev && s:GetPrevNonBlank(lnum)
    let lnum = s:prev_lnum
    let line = getline(lnum)
  endif
  while line =~ '^\s*#' && s:GetPrevNonBlank(lnum)
        \ && synIDattr(synID(lnum, indent(lnum) + 1, 1), "name") =~ s:sh_comment
    let lnum = s:prev_lnum
    let line = getline(lnum)
  endwhile
  unlet! s:prev_lnum
  let line = s:HideCommentStr(line, lnum)

  return [line, lnum]
endfunction

function s:JoinContinueLine(line, lnum)
  let line = a:line
  let lnum = a:lnum
  let line = s:HideCommentStr(line, lnum)
  while line =~ '\\$' && s:GetPrevNonBlank(lnum)
    let lnum = s:prev_lnum
    let line = getline(lnum)
    let [line, lnum] = s:SkipCommentLine(line, lnum, 0)
  endwhile
  unlet! s:prev_lnum

  return line
endfunction

function s:GetPrevNonBlank(lnum)
  let s:prev_lnum = prevnonblank(a:lnum - 1)

  return s:prev_lnum
endfunction

function s:HideCaseLabelLine(line, pline)
  let line = a:line
  if a:line =~ '^\s*[^(].\{-})' && a:line !~ ';;\s*$'
        \ && a:line !~# '^\s*case\>'
        \ && (a:pline =~# '^\s*case\>\|[|&`()]\s*case\>'
        \ || a:pline =~ ';;\s*$')
        \ && a:pline !~# '\s*case\>.*;;\s*esac\>'
    let line = substitute(line, '\\\@<!\%(\\\\\)*\\)', '', 'g')
    let line = substitute(line, '\(\\\@<!\\*"\).\{-}\\\@<!\%(\\\\\)*\1'
          \. '\|\%o47.\{-}\%o47', '', 'g')
    let sum = matchend(line, ')', 0)
    if sum > -1
      let line = strpart(line, sum)
    endif
  elseif a:line =~ '\\$'
        \ && (a:pline =~# '^\s*case\>' && a:pline !~# ';;\s*esac\s*$'
        \ || a:pline =~ ';;\s*$')
    let line = ""
  endif

  return line
endfunction

function s:HideAnyItemLine(line, lnum)
  let line = a:line
  if line =~ '"\|\%o47' && line =~ '[|&`(){}]'
    let line = substitute(line, '"\$\((\)\@!.\{-}"', '', 'g')
    let line = substitute(line, '\(\\\@<!\\*"\).\{-}\\\@<!\%(\\\\\)*\1'
          \. '\|\%o47.\{-}\%o47', '', 'g')
  endif
  if line =~ '\\[()`{}]'
    let line = substitute(line, '\\\@<!\%(\\\\\)*\\[()`{}]', '', 'g')
  endif
  if line =~ '[()`]'
    let line = substitute(line, '\$\=([^()]*\\\@<!\%(\\\\\)*)'
          \. '\|\(\\\@<!`\).\{-}\\\@<!\%(\\\\\)*\1', '', 'g')
    let len = strlen(line)
    while 1
      let line = substitute(line, '\$\=([^()]*\\\@<!\%(\\\\\)*)', '', 'g')
      if len == strlen(line)
        break
      else
        let len = strlen(line)
      endif
    endwhile
  endif

  return line
endfunction

function s:GetTabAndSpaceSum(cline, cind, sstr, sind)
  if a:cline =~ '^\t'
    let tbind = matchend(a:cline, '\t*', 0)
  else
    let tbind = 0
  endif
  let spind = a:cind - tbind * &tabstop
  if a:sstr =~ '<<-' && a:sind
    let tbind = a:sind / &tabstop
  endif

  return [tbind, spind]
endfunction

function s:InsideHereDocIndent(snum, cline)
  let sstr = getline(a:snum)
  if !&expandtab && sstr =~ '<<-' && !strlen(a:cline)
    let ind = indent(a:snum)
  else
    let ind = indent(v:lnum)
  endif
  if !&expandtab && a:cline =~ '^\t'
    let sind = indent(a:snum)
    let [tbind, spind] = s:GetTabAndSpaceSum(a:cline, ind, sstr, sind)
    if spind >= &tabstop
      let b:sh_indent_tabstop = &tabstop
      let &tabstop = spind + 1
    endif
    let ind = tbind * &tabstop + spind
  elseif &expandtab && a:cline =~ '^\t' && sstr =~ '<<-'
    let tbind = matchend(a:cline, '\t*', 0)
    let ind = ind - tbind * &tabstop
  endif

  return ind
endfunction

function s:SkipItemsLines(lnum, item)
  let lnum = a:lnum
  while lnum
    let sum = 0
    for lid in synstack(lnum, 1)
      if synIDattr(lid, 'name') =~ a:item
        let sum = 1
        break
      endif
    endfor
    if sum && s:GetPrevNonBlank(lnum)
      let lnum = s:prev_lnum
      unlet! s:prev_lnum
    else
      unlet! s:prev_lnum
      break
    endif
  endwhile

  return lnum
endfunction

function s:HideCommentStr(line, lnum)
  let line = a:line
  if line =~ '\%(\${\%(\h\w*\|\d\+\)#\=\|\${\=\)\@<!#'
    let sum = match(line, '#', 0)
    while sum > -1
      if synIDattr(synID(a:lnum, sum + 1, 1), "name") =~ s:sh_comment
        let line = strpart(line, 0, sum)
        break
      endif
      let sum = match(line, '#', sum + 1)
    endwhile
  endif

  return line
endfunction

function s:HideQuoteStr(line, lnum, rev)
  let line = a:line
  let sum = match(line, '\%o47\|"', 0)
  while sum > -1
    if synIDattr(synID(a:lnum, sum + 1, 1), "name") =~ s:sh_quote
      if a:rev
        let line = strpart(line, sum + 1)
      else
        let line = strpart(line, 0, sum)
      endif
      break
    endif
    let sum = match(line, '\%o47\|"', sum + 1)
  endwhile

  return line
endfunction

function s:BackQuoteIndent(lnum, ind)
  let line = getline(a:lnum)
  let ind = a:ind
  let lsum = -1
  if line =~ '\\\@<!\%(\\\\\)*`'
    let sum = match(line, '\\\@<!\%(\\\\\)*`', 0)
    while sum > -1
      if synIDattr(synID(a:lnum, sum + 1, 1), "name") =~ s:back_quote
        let sum1 = 0
        let sum2 = 0
        let pnum = 0
        let psum = 0
        for cid in synstack(a:lnum, sum + 1)
          if synIDattr(cid, 'name') =~ s:back_quote
            let sum1 += 1
          endif
        endfor
        if !sum && s:GetPrevNonBlank(a:lnum)
          let pnum = s:prev_lnum
          let pline = getline(pnum)
          let psum = strlen(pline)
        endif
        unlet! s:prev_lnum
        for cid in synstack(pnum ? pnum : a:lnum, psum ? psum : sum)
          if synIDattr(cid, 'name') =~ s:back_quote
            let sum2 += 1
          endif
        endfor
        if sum1 > sum2
          let ind += &sw
        elseif sum1 && sum1 == sum2 && sum == lsum + 1
          let ind += &sw
        elseif sum1 && sum1 == sum2
          let ind -= &sw
        endif
      endif
      let lsum = sum
      let sum = match(line, '\\\@<!\%(\\\\\)*`', sum + 1)
    endwhile
  endif

  return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set sts=2 sw=2 expandtab:
