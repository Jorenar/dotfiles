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
" Description: Omni completion script for cpp files
" Maintainer:  Vissale NEANG
" Last Change: 26 sept. 2007

function! omni#cpp#settings#Init()
    " Global scope search on/off
    "   0 = disabled
    "   1 = enabled
    if !exists('g:OmniCpp_GlobalScopeSearch') 
        let g:OmniCpp_GlobalScopeSearch = 1
    endif

    " Sets the namespace search method
    "   0 = disabled
    "   1 = search namespaces in the current file
    "   2 = search namespaces in the current file and included files
    if !exists('g:OmniCpp_NamespaceSearch') 
        let g:OmniCpp_NamespaceSearch = 1
    endif

    " Set the class scope completion mode
    "   0 = auto
    "   1 = show all members (static, public, protected and private)
    if !exists('g:OmniCpp_DisplayMode') 
        let g:OmniCpp_DisplayMode = 0
    endif

    " Set if the scope is displayed in the abbr column of the popup
    "   0 = no
    "   1 = yes
    if !exists('g:OmniCpp_ShowScopeInAbbr') 
        let g:OmniCpp_ShowScopeInAbbr = 0
    endif

    " Set if the function prototype is displayed in the abbr column of the popup
    "   0 = no
    "   1 = yes
    if !exists('g:OmniCpp_ShowPrototypeInAbbr') 
        let g:OmniCpp_ShowPrototypeInAbbr = 0
    endif
    
    " Set if the access (+,#,-) is displayed
    "   0 = no
    "   1 = yes
    if !exists('g:OmniCpp_ShowAccess') 
        let g:OmniCpp_ShowAccess = 1
    endif

    " Set the list of default namespaces
    " eg: ['std']
    if !exists('g:OmniCpp_DefaultNamespaces') 
        let g:OmniCpp_DefaultNamespaces = []
    endif

    " Set MayComplete to '.'
    "   0 = disabled
    "   1 = enabled
    "   default = 1
    if !exists('g:OmniCpp_MayCompleteDot') 
        let g:OmniCpp_MayCompleteDot = 1
    endif

    " Set MayComplete to '->'
    "   0 = disabled
    "   1 = enabled
    "   default = 1
    if !exists('g:OmniCpp_MayCompleteArrow') 
        let g:OmniCpp_MayCompleteArrow = 1
    endif

    " Set MayComplete to dot
    "   0 = disabled
    "   1 = enabled
    "   default = 0
    if !exists('g:OmniCpp_MayCompleteScope') 
        let g:OmniCpp_MayCompleteScope = 0
    endif

    " When completeopt does not contain longest option, this setting 
    " controls the behaviour of the popup menu selection when starting the completion
    "   0 = don't select first item
    "   1 = select first item (inserting it to the text)
    "   2 = select first item (without inserting it to the text)
    "   default = 0
    if !exists('g:OmniCpp_SelectFirstItem') 
        let g:OmniCpp_SelectFirstItem= 0
    endif

    " Use local search function for variable definitions
    "   0 = use standard vim search function
    "   1 = use local search function
    "   default = 0
    if !exists('g:OmniCpp_LocalSearchDecl') 
        let g:OmniCpp_LocalSearchDecl= 0
    endif
endfunc
