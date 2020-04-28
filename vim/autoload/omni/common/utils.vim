" ============================================================
"
" This file is a part of the omnicppcomplete plugin for vim
"
" Copyright (C) 2006-2012 by Vissale Neang<fromtonrouge at gmail dot com>
"
" This program is free software; you can redistribute it and/or
" modify it under the terms of the GNU General Public License as
" published by the Free Software Foundation; either version 2 of
" the License or (at your option) version 3 or any later version
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.
"
" ============================================================
" Description: Omni completion utils
" Maintainer:  Vissale NEANG
" Last Change: 26 sept. 2007

" For sort numbers in list
function! omni#common#utils#CompareNumber(i1, i2)
    let num1 = eval(a:i1)
    let num2 = eval(a:i2)
    return num1 == num2 ? 0 : num1 > num2 ? 1 : -1
endfunc

" TagList function calling the vim taglist() with try catch
" The only throwed exception is 'TagList:UserInterrupt'
" We also force the noignorecase option to avoid linear search when calling
" taglist()
function! omni#common#utils#TagList(szTagQuery)
    let result = []
    let bUserIgnoreCase = &ignorecase
    " Forcing noignorecase search => binary search can be used in taglist()
    " if tags in the tag file are sorted
    if bUserIgnoreCase
        set noignorecase
    endif
    try
        let result = taglist(a:szTagQuery)
    catch /^Vim:Interrupt$/
        " Restoring user's setting
        if bUserIgnoreCase
            set ignorecase
        endif
        throw 'TagList:UserInterrupt'
    catch
        "Note: it seems that ctags can generate corrupted files, in this case
        "taglist() will fail to read the tagfile and an exception from
        "has_add() is thrown
    endtry

    " Restoring user's setting
    if bUserIgnoreCase
        set ignorecase
    endif
    return result
endfunc

" Same as TagList but don't throw exception
function! omni#common#utils#TagListNoThrow(szTagQuery)
    let result = []
    try
        let result = omni#common#utils#TagList(a:szTagQuery)
    catch
    endtry
    return result
endfunc

" Get the word under the cursor
function! omni#common#utils#GetWordUnderCursor()
    let szLine = getline('.')
    let startPos = getpos('.')[2]-1
    let startPos = (startPos < 0)? 0 : startPos
    if szLine[startPos] =~ '\w'
        let startPos = searchpos('\<\w\+', 'cbn', line('.'))[1] - 1
    endif

    let startPos = (startPos < 0)? 0 : startPos
    let szResult = matchstr(szLine, '\w\+', startPos)
    return szResult
endfunc
