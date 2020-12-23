if !exists('g:loaded_vimpector') | finish | endif

" Init {{{1

let g:vimspector_base_dir            = expand('$XDG_DATA_HOME/vim/vimspector')
let g:vimspector_install_gadgets     = [ 'debugpy', 'vscode-cpptools' ]

if !isdirectory(g:vimspector_base_dir . "/configurations")
  call system("ln -s " . $XDG_CONFIG_HOME."/vim/vimspector" . " " . g:vimspector_base_dir."/configurations")
endif

" Vimspector CLI {{{1

let s:list = {
      \ "!":          "",
      \ "b":          "SetLineBreakpoint(expand('%'), line('.'))",
      \ "c":          "Continue()",
      \ "cl":         "ClearLineBreakpoint(expand('%'), line('.'))",
      \ "cursor":     "RunToCursor()",
      \ "eval":       "Evaluate(",
      \ "f":          "GoToFrame()",
      \ "file":       "",
      \ "fin":        "StepOut()",
      \ "funcBreak":  "AddFunctionBreakpoint(expand('<cexpr>'))",
      \ "pid":        "",
      \ "kill":       "Stop()",
      \ "n":          "StepOver()",
      \ "pause":      "Pause()",
      \ "pCstring":   "",
      \ "q!":         "",
      \ "q":          "",
      \ "restart":    "Restart()",
      \ "s":          "StepInto()",
      \ "toggle":     "ToggleBreakpoint()",
      \ "watch ":     "",
      \ }

function! s:Complete(ArgLead, CmdLine, CursorPos) abort
  let i = a:CursorPos
  let line = a:CmdLine[:i]
  if line =~# "^Vimspector"
    let line = line[11:]
    let i -= 11
  endif

  if i > len(a:ArgLead)
    let cmd = split(line)[0]

    if cmd ==# "file"
      return split(glob(a:ArgLead.'*'), "\n") + [ a:ArgLead ]
    elseif cmd ==# "watch"
      let line = "VimspectorWatch " + line
      let i += 16
      return split(vimspector#CompleteExpr(a:ArgLead, line, i))
    elseif cmd ==# "cl"
      return [ "all" ]
    endif

    return
  endif

  if !exists("g:vimspector_session_windows")
    let list = [
          \ "!",
          \ "b",
          \ "cl",
          \ "file",
          \ "funcBreak",
          \ "toggle",
          \ ]
  else
    let list = keys(s:list)
  endif
  return sort(filter(list, 'v:val =~ "^'.a:ArgLead.'"'))
endfunction

function! s:VimspectorClean() abort
  call system("mv ~/.vimspector.log " . $XDG_CACHE_HOME."/vim/")
  call delete($HOME."/.mono", "rf")
endfunction

function! s:VimspectorClose() abort
  call win_gotoid(g:vimspector_session_windows.code)
  nnoremap <buffer> <Tab> <Tab>
  call win_gotoid(g:vimspector_session_windows.terminal) " to rm it from buffer list
  call vimspector#Stop()
  call vimspector#Reset()
  call s:VimspectorClean()
endfunction

function! s:Vimspector(...) abort
  let cmd  = get(a:, 1, "")

  if a:0 > 2
    let args = join(a:000[1:])
  else
    let args = get(a:, 2, "")
  endif

  if empty(cmd) && !exists("g:vimspector_session_windows")
    call vimspector#LaunchWithSettings( { "PROG": expand('%:p:r') } )

    if !exists("g:vimspector_session_windows")
      call s:VimspectorClean()
    endif

    return
  endif

  if cmd =~# '^q.\?$'
    call s:VimspectorClose()
    if cmd ==# "q!"
      silent! call :silent! vimspector#ClearBreakpoints()
    endif
  elseif cmd ==# "pid"
      call vimspector#LaunchWithSettings( #{ configuration: "GDB-attach" } )
  elseif !empty(args)
    if cmd ==# "!"
      call vimspector#Evaluate('-exec '.args)
    elseif cmd ==# "b"
      call vimspector#SetLineBreakpoint(expand('%'), args)
    elseif cmd ==# "cl"
      if args ==# "all"
        call vimspector#ClearBreakpoints()
      else
        call vimspector#ClearLineBreakpoint(expand('%'), args)
      endif
    elseif cmd ==# "funcBreak"
      call vimspector#AddFunctionBreakpoint(args)
    elseif cmd ==# "watch"
      call vimspector#AddWatch(args)
    elseif cmd ==# "file"
      call vimspector#LaunchWithSettings( { 'PROG': args } )
    elseif cmd ==# "pCstring"
      call vimspector#Evaluate('(char*)'.args)
    elseif has_key(s:list, cmd)
      execute "call vimspector#" . s:list[cmd] . "'" . args . "')"
    endif
  elseif has_key(s:list, cmd)
    execute "call vimspector#".s:list[cmd]
  endif

endfunction

command! -complete=customlist,s:Complete -nargs=* Vimspector call s:Vimspector(<f-args>)

nnoremap <F6> :call <SID>Vimspector()<CR>

" UI {{{1

function! s:CustomiseUI() abort
  for w in keys(g:vimspector_session_windows)
    execute 'call win_gotoid(g:vimspector_session_windows.' . w . ')'
    setlocal laststatus=2
    setlocal statusline=\ %f
    nnoremap <buffer> <Tab> :Vimspector<space>
  endfor

  call win_gotoid(g:vimspector_session_windows.code)

  nunmenu WinBar
  nnoremenu WinBar.Kill  :call vimspector#Stop()<CR>
  nnoremenu WinBar.Cont  :call vimspector#Continue()<CR>
  nnoremenu WinBar.Pause :call vimspector#Pause()<CR>
  nnoremenu WinBar.Next  :call vimspector#StepOver()<CR>
  nnoremenu WinBar.Step  :call vimspector#StepInto()<CR>
  nnoremenu WinBar.Fin   :call vimspector#StepOut()<CR>
  nnoremenu WinBar.↺     :call vimspector#Restart()<CR>
  nnoremenu WinBar.X     :call <SID>VimspectorClose()<CR>

  setlocal statusline=\ %f\ %=%l/%L\ :\ %c

endfunction

augroup MyVimspectorUICustomistaion
  autocmd!
  autocmd User VimspectorUICreated call s:CustomiseUI()
augroup END
