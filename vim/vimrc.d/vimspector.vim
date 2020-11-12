let g:vimspector_base_dir        = expand('$XDG_CONFIG_HOME/vimspector')
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools' ]

let s:list = {
      \ "close":     "",
      \ "continue":  "Continue()",
      \ "cursor":    "RunToCursor()",
      \ "funcBreak": "AddFunctionBreakpoint('<cexpr>')",
      \ "pause":     "Pause()",
      \ "q":         "",
      \ "restart":   "Restart()",
      \ "stepInto":  "StepInto()",
      \ "stepOut":   "StepOut()",
      \ "stepOver":  "StepOver()",
      \ "stop":      "Stop()",
      \ "toggle":    "ToggleBreakpoint()",
      \ }

function! s:compl(ArgLead, ...) abort
  return sort(filter(keys(s:list), 'v:val =~ "^'.a:ArgLead.'"'))
endfunction

function! s:VimspectorClean() abort
  call system("mv ~/.vimspector.log ".g:vimspector_base_dir."/log")
  call delete($HOME."/.mono", "rf")
endfunction

function! s:VimspectorClose() abort
  call vimspector#Reset()
  call s:VimspectorClean()
endfunction

function! s:Vimspector(...) abort
  let cmd = get(a:, 1, "")

  if !exists("g:vimspector_session_windows")
    call vimspector#Launch()
    if !exists("g:vimspector_session_windows")
      call s:VimspectorClean()
    endif
    return
  endif

  if empty(cmd)
    let cmd = input("Vimspector: ", "", "customlist,".get(function("s:compl"), "name"))
  endif

  if cmd == "q" || cmd == "close"
    call s:VimspectorClose()
  elseif has_key(s:list, cmd)
    execute "call vimspector#".s:list[cmd]
  endif

endfunction

function! s:CustomiseUI() abort
  for w in keys(g:vimspector_session_windows)
    execute 'call win_gotoid(g:vimspector_session_windows.' . w . ')'
    setlocal laststatus=2
    setlocal statusline=\ %f
    nnoremap <buffer> <Tab> :call <SID>Vimspector()<CR>
  endfor

  call win_gotoid(g:vimspector_session_windows.code)
  nnoremenu WinBar.✕ :Vimspector close<CR>
  setlocal statusline=\ %f\ %=%l/%L\ :\ %c

endfunction

augroup MyVimspectorUICustomistaion
  autocmd!
  autocmd User VimspectorUICreated call s:CustomiseUI()
augroup END

command! -complete=customlist,s:compl -nargs=? Vimspector call s:Vimspector("<args>")

nnoremap <F6> :call <SID>Vimspector()<CR>
