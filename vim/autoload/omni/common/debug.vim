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
" Description: Omni completion debug functions
" Maintainer:  Vissale NEANG
" Last Change: 26 sept. 2007

let s:CACHE_DEBUG_TRACE = []

" Start debug, clear the debug file
function! omni#common#debug#Start()
    let s:CACHE_DEBUG_TRACE = []
    call extend(s:CACHE_DEBUG_TRACE, ['============ Debug Start ============'])
    call writefile(s:CACHE_DEBUG_TRACE, "Omni.dbg")
endfunc

" End debug, write to debug file
function! omni#common#debug#End()
    call extend(s:CACHE_DEBUG_TRACE, ["============= Debug End ============="])
    call extend(s:CACHE_DEBUG_TRACE, [""])
    call writefile(s:CACHE_DEBUG_TRACE, "Omni.dbg")
endfunc

" Debug trace function
function! omni#common#debug#Trace(szFuncName, ...)
    let szTrace = a:szFuncName
    let paramNum = a:0
    if paramNum>0
        let szTrace .= ':'
    endif
    for i in range(paramNum)
        let szTrace = szTrace .' ('. string(eval('a:'.string(i+1))).')'
    endfor
    call extend(s:CACHE_DEBUG_TRACE, [szTrace])
endfunc
