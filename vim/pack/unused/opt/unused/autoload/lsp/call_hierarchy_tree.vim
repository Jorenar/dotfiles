function! s:hierarchy_treeitem_command(item) abort
  silent! wincmd p
  call lsp#utils#tagstack#_update()
  call lsp#utils#location#_open_lsp_location(a:item)

  " exit visual mode for some reason set by the previous function
  exec "normal! \<Esc>"
endfunction

function! s:request(bufnr, method, params, handler) abort
  let l:servers = filter(lsp#get_allowed_servers(a:bufnr), 'lsp#capabilities#has_call_hierarchy_provider(v:val)')

  if len(l:servers) == 0
    return lsp#utils#error('Retrieving CALL hierarchy not supported for ' . &filetype)
  endif

  for l:server in l:servers
    call lsp#send_request(l:server, {
          \   'method': a:method,
          \   'params': a:params,
          \   'on_notification': a:handler,
          \ })
  endfor
endfunction

function! s:get_children(Callback, ...) dict abort
  if a:0 == 0
    call a:Callback('success', [l:self.root])
    return
  endif

  let l:data = a:1

  " Children already retrieved
  if exists('l:data.response.result') && len(l:data.response.result) > 0
    call a:Callback('success', l:data.response.result)
    return
  endif

  let l:params = { 'item': l:data[l:self.callDirection] }
  let l:Handler = {data -> a:Callback('success', data.response.result)}

  call s:request(l:self.bufnr, l:self.method, l:params, l:Handler)
endfunction

function! s:get_parent(Callback, data) dict abort
  call a:Callback('failure')
endfunction

function! s:collapse_setter(_, data) dict abort
  let l:self.collapseState = empty(a:data) ? "none" : "collapsed"
endfunction

function! s:get_tree_item(Callback, data) dict abort
  if has_key(a:data, "request")
    let l:item = a:data.request.params.item
    let l:self.collapseState = 'expanded'
  else
    let l:item = a:data[l:self.callDirection]
    call l:self.set_collapse({ l:self.callDirection: l:item })
    sleep 1m
  endif

  let l:tree_item = {
        \   'label': l:item.name,
        \   'command': function('s:hierarchy_treeitem_command', [l:item]),
        \   'collapsibleState': l:self.collapseState,
        \ }

  " Reset 'collapseState' to safe 'collapsed', bc it may linger
  let l:self.collapseState = 'collapsed'

  call a:Callback('success', l:tree_item)
endfunction

function! s:handle_tree(bufnr, method, data) abort
  if type(a:data) != v:t_dict
    call lsp#util#warning('No hierarchy for the object under cursor')
    return
  endif

  let l:provider = {
        \   'root': a:data,
        \   'method': a:method,
        \   'bufnr': a:bufnr,
        \   'callDirection': a:method =~ 'incoming' ? 'from' : 'to',
        \   'getChildren': function('s:get_children'),
        \   'getParent': function('s:get_parent'),
        \   'getTreeItem': function('s:get_tree_item'),
        \   'collapse_handler': function('s:collapse_setter')
        \ }
  let l:provider.set_collapse = function('s:get_children', [l:provider.collapse_handler])

  " Create new buffer in a vertical split
  topleft 50vnew
  vertical resize 50
  setlocal winfixwidth
  call lsp#disable_diagnostics_for_buffer() " and disable diagnostics in it
  let &l:stl = " " . (a:method =~ 'incoming' ? "Incoming" : "Outgoing") . " Calls"

  call lsp#utils#tree#new(l:provider)
endfunction

function! s:handle_prepare_call_hierarchy(bufnr, method, data) abort
  let l:Handler = function('s:handle_tree', [a:bufnr, a:method])
  let l:params = { 'item': a:data.response.result[0] }
  call s:request(a:bufnr, a:method, l:params, l:Handler)
endfunction

function! lsp#call_hierarchy_tree#show(out) abort
  let l:bufnr = bufnr('%')
  let l:method = 'callHierarchy/' . (a:out ? 'outgoingCalls' : 'incomingCalls')
  let l:Handler = function('s:handle_prepare_call_hierarchy', [l:bufnr, l:method])

  let l:params = {
        \   'textDocument': lsp#get_text_document_identifier(),
        \   'position': lsp#get_position(),
        \ }
  call s:request(l:bufnr, 'textDocument/prepareCallHierarchy', l:params, l:Handler)
endfunction
