function! stl#FileSize() abort
  let [ bytes, units, i ] = [ getfsize(expand(@%)), ['', 'Ki', 'Mi', 'Gi'], 0 ]
  while bytes >= 1024 | let bytes = bytes / 1024.0 | let i += 1 | endwhile
  return printf((i ? "~%.1f" : "%d")." %sB", bytes, units[i])
endfunction

function! stl#IssuesCount() abort
  let errors   = len(filter(getqflist(), 'v:val.type == "E"'))
  let warnings = len(filter(getqflist(), 'v:val.type == "w"'))
  if g:lsp_loaded
    let lsp_count = lsp#get_buffer_diagnostics_counts()
    let errors   += lsp_count.error
    let warnings += lsp_count.warning
  endif
  return errors."E ".warnings."w"
endfunction

function! stl#ModifBufs() abort
  let cnt = len(filter(getbufinfo(), 'v:val.changed'))
  return cnt == 0 ? "" : (&mod ? "[+". (cnt > 1 ? cnt : "") ."]" : "[".cnt."]")
endfunction

function! stl#NumOfBufs() abort
  let num = len(getbufinfo({'buflisted':1}))
  let hid = len(filter(getbufinfo({'buflisted':1}), 'empty(v:val.windows)'))
  return hid ? (num-hid)."+".hid : num
endfunction
