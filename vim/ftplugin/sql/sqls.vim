" Modified https://github.com/lighttiger2505/sqls.vim

if !executable('sqls') | finish | endif

let s:commands = {}

function! s:_execute_query(selection) abort
  let l:mode = 'n'
  if a:selection
    let l:mode = 'v'
  endif
  call s:execute_query(l:mode)
endfunction

function! s:execute_query(mode) abort
  let l:args = {
        \   'server_name': 'sqls',
        \   'command_name': 'executeQuery',
        \   'command_args': [get(lsp#get_text_document_identifier(), 'uri', v:null)],
        \   'callback_func': 's:handle_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ }
  if a:mode ==# 'v'
    let l:args['command_range'] = lsp#utils#range#_get_recent_visual_range()
  endif
  call s:lsp_execute_command(args)
endfunction

function! s:_execute_query_vertical(selection) abort
  let l:mode = 'n'
  if a:selection
    let l:mode = 'v'
  endif
  call s:execute_query_vertical(l:mode)
endfunction

function! s:execute_query_vertical(mode) abort
  let l:args = {
        \   'server_name': 'sqls',
        \   'command_name': 'executeQuery',
        \   'command_args': [get(lsp#get_text_document_identifier(), 'uri', v:null), '-show-vertical'],
        \   'callback_func': 's:handle_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ }
  if a:mode ==# 'v'
    let l:args['command_range'] = lsp#utils#range#_get_recent_visual_range()
  endif
  call s:lsp_execute_command(args)
endfunction

function! s:show_databases() abort
  call s:lsp_execute_command({
        \   'server_name': 'sqls',
        \   'command_name': 'showDatabases',
        \   'command_args': v:null,
        \   'callback_func': 's:handle_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ })
endfunction

function! s:show_schemas() abort
  call s:lsp_execute_command({
        \   'server_name': 'sqls',
        \   'command_name': 'showSchemas',
        \   'command_args': v:null,
        \   'callback_func': 's:handle_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ })
endfunction

function! s:show_connections() abort
  call s:lsp_execute_command({
        \   'server_name': 'sqls',
        \   'command_name': 'showConnections',
        \   'command_args': v:null,
        \   'callback_func': 's:handle_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ })
endfunction

function! s:show_tables() abort
  echo 'no implements'
endfunction

function! s:describe_table() abort
  echo 'no implements'
endfunction

function! s:switch_database(db_name) abort
  call s:lsp_execute_command({
        \   'server_name': 'sqls',
        \   'command_name': 'switchDatabase',
        \   'command_args': [a:db_name],
        \   'callback_func': 's:handle_no_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ })
  return
endfunction

function! s:switch_connection(conn_index) abort
  call s:lsp_execute_command({
        \   'server_name': 'sqls',
        \   'command_name': 'switchConnections',
        \   'command_args': [a:conn_index],
        \   'callback_func': 's:handle_no_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ })
  return
endfunction

function! s:lsp_execute_command(params) abort
  let l:command_name = a:params['command_name']
  let l:command_args = get(a:params, 'command_args', v:null)
  let l:command_range = get(a:params, 'command_range', v:null)
  let l:server_name = get(a:params, 'server_name', '')
  let l:callback_func = get(a:params, 'callback_func', 's:handle_no_preview')
  let l:bufnr = get(a:params, 'bufnr', -1)
  let l:sync = get(a:params, 'sync', v:false)

  " create command.
  let l:command = { 'command': l:command_name }
  if l:command_args isnot v:null
    let l:command['arguments'] = l:command_args
  endif
  if l:command_range isnot v:null
    let l:command['range'] = l:command_range
  endif

  " execute command on local.
  if has_key(s:commands, l:command_name)
    try
      call s:commands[l:command_name]({
            \   'bufnr': l:bufnr,
            \   'server_name': l:server_name,
            \   'command': l:command,
            \ })
    catch /.*/
      call lsp#utils#error(printf('Execute command failed: %s', string(a:params)))
    endtry
    return
  endif

  " execute command on server.
  if !empty(l:server_name)
    call lsp#send_request(l:server_name, {
          \   'method': 'workspace/executeCommand',
          \   'params': l:command,
          \   'sync': l:sync,
          \   'on_notification': function(l:callback_func, [l:server_name, l:command]),
          \ })
  endif
  echo 'Do ' . l:command_name
endfunction


function! s:handle_no_preview(server_name, command, data) abort
  if lsp#client#is_error(a:data['response'])
    call lsp#utils#error('Execute command failed on ' . a:server_name . ': ' . string(a:command) . ' -> ' . string(a:data))
    return
  endif

  echo get(a:command, 'command', '') . ' Done'
endfunction

function! s:handle_preview(server_name, command, data) abort
  if lsp#client#is_error(a:data['response'])
    call lsp#utils#error('Execute command failed on ' . a:server_name . ': ' . string(a:command) . ' -> ' . string(a:data))
    return
  endif

  call s:open_preview_buffer(a:data['response']['result'], 'LSP ExecuteCommand')
  echo get(a:command, 'command', '') . ' Done'
endfunction

function! s:escape_string_for_display(str) abort
  return substitute(substitute(a:str, '\r\n', '\n', 'g'), '\r', '\n', 'g')
endfunction

function! s:open_preview_buffer(data, buf_filetype) abort
  if !exists("s:preview_win_id") || !win_gotoid(s:preview_win_id)
    new
    let s:preview_win_id = win_getid()
  else
    %d_
  endif

  " set preview content
  call setline(1, split(s:escape_string_for_display(a:data), '\n'))

  " setup preview window
  setlocal
        \ bufhidden=wipe nomodified nobuflisted noswapfile nonumber
        \ nocursorline nowrap nonumber norelativenumber signcolumn=no nofoldenable
        \ nospell nolist nomodeline
  silent! let &l:filetype = a:buf_filetype

  " set the focus to the preview window
  call win_gotoid(s:preview_win_id)
endfunction

function! s:get_selection_pos(type) abort
  if a:type ==? 'v'
    let l:start_pos = getpos("'<")[1:2]
    let l:end_pos = getpos("'>")[1:2]
    " fix end_pos column (see :h getpos() and :h 'selection')
    let l:end_line = getline(l:end_pos[0])
    let l:offset = (&selection ==# 'inclusive' ? 1 : 2)
    let l:end_pos[1] = len(l:end_line[:l:end_pos[1]-l:offset])
    " edge case: single character selected with selection=exclusive
    if l:start_pos[0] == l:end_pos[0] && l:start_pos[1] > l:end_pos[1]
      let l:end_pos[1] = l:start_pos[1]
    endif
  elseif a:type ==? 'line'
    let l:start_pos = [line("'["), 1]
    let l:end_lnum = line("']")
    let l:end_pos = [line("']"), len(getline(l:end_lnum))]
  elseif a:type ==? 'char'
    let l:start_pos = getpos("'[")[1:2]
    let l:end_pos = getpos("']")[1:2]
  else
    let l:start_pos = [0, 0]
    let l:end_pos = [0, 0]
  endif

  return l:start_pos + l:end_pos
endfunction


command! -range SqlsExecuteQuery call s:_execute_query(<range> != 0)
command! -range SqlsExecuteQueryVertical call s:_execute_query_vertical(<range> != 0)
command! SqlsShowDatabases call s:show_databases()
command! SqlsShowSchemas call s:show_schemas()
command! SqlsShowConnections call s:show_connections()
command! SqlsDescribeTable call s:describe_table()
command! -nargs=1 SqlsSwitchDatabase call s:switch_database("<args>")
command! -nargs=1 SqlsSwitchConnection call s:switch_connection("<args>")
"command! SqlsShowTables call s:show_tables()

nnoremap <F8> :w <bar> <C-u>call <SID>execute_query('n')<CR>
vnoremap <F8> :w <bar> <C-u>call <SID>execute_query('v')<CR>
