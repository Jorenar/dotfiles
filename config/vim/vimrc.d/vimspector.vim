scriptencoding utf-8

let g:vimspector_base_dir = $XDG_DATA_HOME . '/vim/vimspector'
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools' ]

command! Vimspector call vimspector#Launch()

augroup VIMSPECTOR_INIT
  autocmd!

  function! s:Init()
    if !exists('g:loaded_vimpector')
      delcommand Vimspector
      return
    endif

    let l:confs = g:vimspector_base_dir . '/configurations'
    if mkdir(g:vimspector_base_dir, 'p') && !isdirectory(l:confs)
      call system('ln -s '.$XDG_CONFIG_HOME.'/vim/vimspector'.' '.l:confs)
    endif
  endfunction

  autocmd VimEnter * call s:Init()

  autocmd VimLeave *
        \  if filereadable($HOME."/.vimspector.log")
        \|   call system("mv ~/.vimspector.log " . $XDG_STATE_HOME."/vim/vimspector.log")
        \| endif

augroup END

augroup VimspectorUICustomisation
  autocmd!

  function! s:mappings() abort
    for m in [
          \   [ 'n', 'd',  ':<C-u>Vimspector' ],
          \   [ 'n', 'd:', ':<C-u>Vimspector' ],
          \   [ 'n', 'db', '<Plug>VimspectorToggleBreakpoint' ],
          \   [ 'n', 'df', '<Plug>VimspectorJumpToProgramCounter' ],
          \   [ 'n', 'dr', '<Plug>VimspectorRunToCursor' ],
          \   [ 'n', 'dk', '<Plug>VimspectorBalloonEval' ],
          \   [ 'x', 'dk', '<Plug>VimspectorBalloonEval' ],
          \ ]
      exec m[0].'map <silent> <Leader>'.m[1].' '.m[2]
    endfor
  endfunction

  function! s:ui_base() abort
    if has('nvim')
      autocmd OptionSet winbar
            \ call win_gotoid(g:vimspector_session_windows.code) |
            \ let &l:winbar = ''
            \ . '%#ToolbarButton#%0@vimspector#internal#neowinbar#Do@ Kill %X%*'
            \ . '%#ToolbarButton#%1@vimspector#internal#neowinbar#Do@ Cont %X%*'
            \ . '%#ToolbarButton#%2@vimspector#internal#neowinbar#Do@ Pause %X%*'
            \ . '%#ToolbarButton#%3@vimspector#internal#neowinbar#Do@ Next %X%*'
            \ . '%#ToolbarButton#%4@vimspector#internal#neowinbar#Do@ Step %X%*'
            \ . '%#ToolbarButton#%5@vimspector#internal#neowinbar#Do@ Out %X%*'
            \ . '%#ToolbarButton#%6@vimspector#internal#neowinbar#Do@ ↺ %X%*'
            \ . '%#ToolbarButton#%7@vimspector#internal#neowinbar#Do@ X %X%*'
    else
      call win_gotoid(g:vimspector_session_windows.code)
      nunmenu WinBar
      nnoremenu WinBar.Kill  <Cmd>call vimspector#Stop({ 'interactive': v:false })<CR>
      nnoremenu WinBar.Cont  <Cmd>call vimspector#Continue()<CR>
      nnoremenu WinBar.Pause <Cmd>call vimspector#Pause()<CR>
      nnoremenu WinBar.Next  <Cmd>call vimspector#StepOver()<CR>
      nnoremenu WinBar.Step  <Cmd>call vimspector#StepInto()<CR>
      nnoremenu WinBar.Out   <Cmd>call vimspector#StepOut()<CR>
      nnoremenu WinBar.↺     <Cmd>call vimspector#Restart()<CR>
      nnoremenu WinBar.X     <Cmd>call vimspector#Reset({ 'interactive': v:false })<CR>
    endif

    VimspectorBreakpoints

    const wins = g:vimspector_session_windows

    for w in keys(wins)
      call win_execute(wins[w], 'setl stl=\ %f nofen')
    endfor

    call win_execute(wins.stack_trace, 'wincmd K')
    call win_splitmove(wins.variables, wins.stack_trace, #{ vertical: 1 })
    call win_splitmove(wins.watches, wins.variables, #{ vertical: 1 })
    call win_execute(wins.stack_trace, 'resize 8')

    call win_splitmove(wins.output, wins.code, #{ vertical: 1 })
    call win_splitmove(wins.breakpoints, wins.output, #{ vertical: 0 })

    call win_execute(wins.stack_trace, 'resize 7')
    call win_execute(wins.breakpoints, 'resize 6')

    call win_gotoid(wins.output)
    setlocal nolist
    autocmd WinEnter <buffer> startinsert
  endfunction

  function! s:ui_term() abort
    const wins = g:vimspector_session_windows
    call win_execute(wins.terminal, 'setl stl=\ %f nofen')
    call win_splitmove(wins.terminal, wins.output)
    call win_splitmove(wins.output, wins.terminal)
    call win_execute(wins.terminal, 'resize 16')
    call win_execute(wins.terminal, 'vert resize 90')
  endfunction

  function! s:ui_disasm() abort
    setl stl=\ vimspector.Disassembly\ %=\ %l/%L
    autocmd TextChanged <buffer> setl cc= scl=yes:2
    const wins = g:vimspector_session_windows
    call win_splitmove(wins.disassembly, wins.code)
  endfunction

  autocmd User VimspectorUICreated call s:mappings()
  autocmd User VimspectorUICreated call s:ui_base()
  autocmd User VimspectorTerminalOpened call s:ui_term()
  autocmd FileType vimspector-disassembly call s:ui_disasm()

augroup END

augroup VIMSPECTOR_COMMAND_HISTORY
  " https://github.com/puremourning/vimspector/issues/52#issuecomment-699027787

  autocmd!

  function! InitializeVimspectorCommandHistory()
    if !exists('b:vimspector_command_history')
      inoremap <silent> <buffer> <CR> <C-o>:call VimspectorCommandHistoryAdd()<CR>
      inoremap <silent> <buffer> <Up> <C-o>:call VimspectorCommandHistoryUp()<CR>
      inoremap <silent> <buffer> <Down> <C-o>:call VimspectorCommandHistoryDown()<CR>
      let b:vimspector_command_history = []
      let b:vimspector_command_history_pos = 0
    endif
  endfunction
  function! VimspectorCommandHistoryAdd()
    call add(b:vimspector_command_history, getline('.'))
    let b:vimspector_command_history_pos = len(b:vimspector_command_history)
    call feedkeys("\<CR>", 'tn')
  endfunction
  function! VimspectorCommandHistoryUp()
    if len(b:vimspector_command_history) == 0 || b:vimspector_command_history_pos == 0
      return
    endif
    call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
    call feedkeys("\<C-o>A", 'tn')
    let b:vimspector_command_history_pos = b:vimspector_command_history_pos - 1
  endfunction
  function! VimspectorCommandHistoryDown()
    if b:vimspector_command_history_pos == len(b:vimspector_command_history)
      return
    endif
    call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
    call feedkeys("\<C-o>A", 'tn')
    let b:vimspector_command_history_pos = b:vimspector_command_history_pos + 1
  endfunction

  autocmd FileType VimspectorPrompt call InitializeVimspectorCommandHistory()
augroup end
