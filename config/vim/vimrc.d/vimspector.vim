scriptencoding utf-8

let g:vimspector_base_dir = $XDG_DATA_HOME . '/vim/vimspector'
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools' ]

let g:vimspector_sidebar_width = 30
let g:vimspector_bottombar_height = 10

command! Vimspector call vimspector#Launch()

function! s:Eval(...) abort
  call win_gotoid(g:vimspector_session_windows.output)
  startinsert
  call feedkeys(get(a:, 1, ''), 'n')
endfunction

augroup VIMSPECTOR_INIT
  autocmd!

  function! s:Init()
    if !exists('g:loaded_vimpector')
      delcommand Vimspector
      return
    endif

    call mkdir(g:vimspector_base_dir, 'p')
    let s:confs = g:vimspector_base_dir . '/configurations'
    if !isdirectory(s:confs)
      call system('ln -s '.$XDG_CONFIG_HOME.'/vim/vimspector'.' '.s:confs)
    endif
    unlet s:confs

    nnoremap <expr> <F6> exists("g:vimspector_session_windows") ? ":VimspectorReset\<CR>" :
          \ ":Vimspector " . expand('%:p:r') . "\<CR>"

    let s:mappings = [
          \   [ 'n', 'dB', '<Plug>VimspectorAddFunctionBreakpoint' ],
          \   [ 'n', 'db', '<Plug>VimspectorToggleBreakpoint'      ],
          \   [ 'n', 'dc', '<Plug>VimspectorContinue'              ],
          \   [ 'n', 'df', '<Plug>VimspectorStepOut'               ],
          \   [ 'n', 'di', '<Plug>VimspectorBalloonEval'           ],
          \   [ 'n', 'dj', '<Plug>VimspectorDownFrame'             ],
          \   [ 'n', 'dk', '<Plug>VimspectorUpFrame'               ],
          \   [ 'n', 'dm', '<Plug>VimspectorRunToCursor'           ],
          \   [ 'n', 'dn', '<Plug>VimspectorStepOver'              ],
          \   [ 'n', 'dp', '<Plug>VimspectorPause'                 ],
          \   [ 'n', 'dq', '<Plug>VimspectorStop'                  ],
          \   [ 'n', 'dR', '<Plug>VimspectorRestart'               ],
          \   [ 'n', 'ds', '<Plug>VimspectorStepInto'              ],
          \   [ 'x', 'di', '<Plug>VimspectorBalloonEval'           ],
          \   [ 'nnore', 'de', ':call <SID>Eval()<CR>'             ],
          \   [ 'nnore', 'dx', ":call <SID>Eval('-exec ')<CR>"     ],
          \ ]

    for m in s:mappings
      exec m[0].'map <silent> <buffer> <leader>'.m[1].' '.m[2]
    endfor
  endfunction

  autocmd VimEnter * call s:Init()

  autocmd VimLeave *
        \  if filereadable($HOME."/.vimspector.log")
        \|   call system("mv ~/.vimspector.log " . $XDG_STATE_HOME."/vim/vimspector.log")
        \| endif

augroup END

augroup VimspectorUICustomisation
  autocmd!

  function! s:layout_p1() abort
    autocmd FileType vimspector-disassembly
          \ setl stl=\ vimspector.Disassembly\ %=\ %l/%L\ |
          \ autocmd TextChanged <buffer> setl cc= scl=yes:2

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
  endfunction

  function! s:layout_p2() abort
    VimspectorDisassemble
    VimspectorBreakpoints

    const wins = g:vimspector_session_windows

    for w in keys(wins)
      call win_execute(wins[w], 'setl stl=\ %f nofen')
    endfor

    call win_execute(wins.stack_trace, 'wincmd K')
    call win_splitmove(wins.variables, wins.stack_trace, #{ vertical: 1 })
    call win_splitmove(wins.watches, wins.variables, #{ vertical: 1 })
    call win_execute(wins.stack_trace, 'resize 8')

    call win_splitmove(wins.breakpoints, wins.code, #{ vertical: 1 })
    call win_splitmove(wins.terminal, wins.breakpoints, #{ vertical: 0 })
    call win_splitmove(wins.output, wins.terminal, #{ vertical: 0 })
    call win_splitmove(wins.breakpoints, wins.output, #{ vertical: 0 })

    call win_splitmove(wins.disassembly, wins.code, #{ vertical: 0 })

    call win_execute(wins.stack_trace, 'resize 7')
    call win_execute(wins.disassembly, 'resize 7')
    call win_execute(wins.terminal, 'resize 16')
    call win_execute(wins.terminal, 'vert resize 90')
    call win_execute(wins.breakpoints, 'resize 6')

  endfunction

  autocmd User VimspectorUICreated call s:layout_p1()
  autocmd User VimspectorTerminalOpened call s:layout_p2()

augroup END
