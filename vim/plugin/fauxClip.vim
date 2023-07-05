" fauxClip - Clipboard support without +clipboard
" Maintainer:  Jorengarenar <dev@joren.ga>

if exists("g:loaded_fauxClip") | finish | endif
if has("clipboard") && !get(g:, "fauxClip_always_use", 0) | finish | endif

let s:cpo_save = &cpo | set cpo&vim

function s:init() abort
  let settedCmds = 0
  for v in [ "copy", "copy_primary", "paste", "paste_primary" ]
    let settedCmds += exists("g:fauxClip_".v."_cmd")
  endfor

  if settedCmds < 4
    let cmds = {}
    if $WSL2_GUI_APPS_ENABLED && (executable("xclip") || executable("xsel"))
      if executable("xclip")
        let cmds = {
              \   "copy": "xclip -f -i -selection clipboard",
              \   "paste": "xclip -o -selection clipboard",
              \ }
      elseif executable("xsel")
        let cmds = {
              \   "copy": "xsel -i -b",
              \   "paste": "xsel -o -b",
              \ }
      endif
    elseif executable("clip.exe")
      let cmds = {
            \   "copy": "clip.exe",
            \   "paste": "powershell.exe Get-Clipboard",
            \ }
      let cmds["paste"] .= " | sed -Ez 's/\\r//g; $ s/\\n+$//'"
    elseif executable("pbcopy")
      let cmds = {
            \   "copy": "pbcopy",
            \   "paste": "pbpaste",
            \ }
    elseif executable("xclip")
      let cmds = {
            \   "copy": {
            \     "clipboard": "xclip -f -i -selection clipboard",
            \     "primary": "xclip -f -i",
            \   },
            \   "paste": {
            \     "clipboard": "xclip -o -selection clipboard",
            \     "primary": "xclip -o",
            \   }
            \ }
    elseif executable("xsel")
      let cmds = {
            \   "copy": {
            \     "clipboard": "xsel -i -b",
            \     "primary": "xsel -i",
            \   },
            \   "paste": {
            \     "clipboard": "xsel -o -b",
            \     "primary": "xclip -o",
            \   }
            \ }
    elseif executable("wl-copy")
      let cmds = {
            \   "copy": {
            \     "clipboard": "wl-copy",
            \     "primary": "wl-copy --primary",
            \   },
            \   "paste": {
            \     "clipboard": "wl-paste --no-newline",
            \     "primary": "wl-paste --primary --no-newline",
            \   }
            \ }
    else
      autocmd VimEnter * ++once
            \  echohl ErrorMsg
            \|  echo "fauxClip: not all commands are set and could not find any of the defaults"
            \| echohl None
      return
    endif

    let copy = cmds["copy"]
    let isStr = type(copy) == 1
    if !exists("g:fauxClip_copy_cmd")
      let g:fauxClip_copy_cmd = isStr ? copy : copy["clipboard"]
      let settedCmds += 1
    endif
    if !exists("g:fauxClip_copy_primary_cmd")
      let g:fauxClip_copy_primary_cmd = isStr ? copy : copy["primary"]
      let settedCmds += 1
    endif

    let paste = cmds["paste"]
    let isStr = type(paste) == 1
    if !exists("g:fauxClip_paste_cmd")
      let g:fauxClip_paste_cmd = isStr ? paste : paste["clipboard"]
      let settedCmds += 1
    endif
    if !exists("g:fauxClip_paste_primary_cmd")
      let g:fauxClip_paste_primary_cmd = isStr ? paste : paste["primary"]
      let settedCmds += 1
    endif
  endif

  if get(g:, "fauxClip_suppress_errors", 1)
    let null = (executable("clip.exe") && !has("unix")) ? " 2> NUL" : " 2> /dev/null"
    let g:fauxClip_copy_cmd          .= null
    let g:fauxClip_paste_cmd         .= null
    let g:fauxClip_copy_primary_cmd  .= null
    let g:fauxClip_paste_primary_cmd .= null
  endif

  let s:tmux_reg = get(g:, "fauxClip_tmux_reg", ']')
endfunction
call s:init()

" Runtime functions {{{

function! s:start(REG) abort
  let s:REG = a:REG
  let s:reg = [getreg('"'), getregtype('"')]

  let @@ = s:paste(s:REG)

  augroup fauxClip
    autocmd!
    if exists('##TextYankPost')
      autocmd TextYankPost * if v:event.regname == '"' | call s:yank(v:event.regcontents) | endif
    else
      autocmd CursorMoved  * if @@ != s:reg | call s:yank(@@) | endif
    endif
    autocmd TextChanged  * call s:end()
  augroup END

  return '""'
endfunction

function! s:yank(content) abort
  if s:REG == "+"
    call system(g:fauxClip_copy_cmd, a:content)
  elseif s:REG == "*"
    call system(g:fauxClip_copy_primary_cmd, a:content)
  elseif s:REG == s:tmux_reg
    call system("tmux load-buffer -", a:content)
  endif

  call s:end()
endfunction

function! s:paste(REG) abort
  if a:REG == "+"
    return system(g:fauxClip_paste_cmd)
  elseif a:REG == "*"
    return system(g:fauxClip_paste_primary_cmd)
  elseif a:REG == s:tmux_reg
    return system("tmux save-buffer -")
  endif
endfunction

function! s:end() abort
  augroup fauxClip
    autocmd!
  augroup END
  call setreg('"', s:reg[0], s:reg[1])
  unlet! s:reg s:REG
  redraw
endfunction

function! s:cmd(cmd, REG) abort range
  let s:REG = a:REG
  let s:reg = [getreg('"'), getregtype('"')]
  if a:cmd =~# 'pu\%[t]'
    execute a:firstline . ',' . a:lastline . a:cmd ."=s:paste(s:REG)"
    call s:end()
  else
    execute a:firstline . ',' . a:lastline . a:cmd
    call s:yank(getreg('"'))
  endif
endfunction

function! s:restore_CR() abort
  if empty(g:CR_old)
    cunmap <CR>
  else
    execute   (g:CR_old["noremap"] ? "cnoremap " : "cmap ")
          \ . (g:CR_old["silent"]  ? "<silent> " : "")
          \ . (g:CR_old["nowait"]  ? "<nowait> " : "")
          \ . (g:CR_old["expr"]    ? "<expr> "   : "")
          \ . (g:CR_old["buffer"]  ? "<buffer> " : "")
          \ . g:CR_old["lhs"]." ".g:CR_old["rhs"]
  endif
  unlet g:CR_old
endfunction

function! s:cmd_pattern() abort
  return '\v%(%(^|\|)\s*%(\%|\d\,\d|' . "'\\<\\,'\\>" . ')?\s*)@<=(y%[ank]|d%[elete]|pu%[t]!?)\s*(['.s:tmux_reg.'+*])'
endfunction

function! s:CR() abort
  call s:restore_CR()
  call histadd(":", getcmdline())
  let sid = matchstr(expand("<sfile>"), '<SNR>\d\+_')
  return substitute(getcmdline(),
        \ s:cmd_pattern(),
        \ 'call '.sid.'cmd(''\1'', ''\2'')', 'g')
        \ . " | call histdel(':', -1)"
endfunction

" }}}

" Mappings {{{

augroup fauxClipCmdWrapper
  autocmd!
  autocmd CmdlineChanged : if getcmdline() =~# <SID>cmd_pattern()
        \| if !exists('g:CR_old') | let g:CR_old = maparg('<CR>', 'c', '', 1) | endif
        \| cnoremap <expr> <silent> <CR> getcmdline() =~# <SID>cmd_pattern() ? '<C-u>'.<SID>CR().'<CR>' : '<CR>'
        \| elseif exists('g:CR_old') | call <SID>restore_CR() | endif
augroup END

for r in [ '*', '+', s:tmux_reg ]
  exec 'nnoremap <expr> "'.r '<SID>start("'.r.'")'
  exec 'vnoremap <expr> "'.r '<SID>start("'.r.'")'

  exec 'noremap! <C-r>'.r       '<C-r>=<SID>paste("'.r.'")<CR>'
  exec 'noremap! <C-r><C-r>'.r  '<C-r><C-r>=<SID>paste("'.r.'")<CR>'
  exec 'noremap! <C-r><C-o>'.r  '<C-r><C-o>=<SID>paste("'.r.'")<CR>'
  exec 'inoremap <C-r><C-p>'.r  '<C-r><C-p>=<SID>paste("'.r.'")<CR>'
endfor | unlet r

" }}}

let g:loaded_fauxClip = 1
let &cpo = s:cpo_save | unlet s:cpo_save
