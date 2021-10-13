function! stl#FileSize() abort
  let [ bytes, units, i ] = [ getfsize(expand(@%)), ['', 'Ki', 'Mi', 'Gi'], 0 ]
  while bytes >= 1024 | let bytes = bytes / 1024.0 | let i += 1 | endwhile
  return printf((i ? "~%.1f" : "%d")." %sB", bytes, units[i])
endfunction

function! stl#IssuesCount() abort
  let errors   = filter(getqflist(), 'v:val.type == "E"')
  let warnings = filter(getqflist(), 'v:val.type == "w"')
  return len(errors)."E ".len(warnings)."w"
endfunction

function! stl#ModifBufs() abort
  let cnt = len(filter(getbufinfo(), 'v:val.changed'))
  return cnt == 0 ? "" : (&mod ? "[+". (cnt > 1 ? cnt : "") ."]" : "[".cnt."]")
endfunction

function! stl#NumOfBufs() abort
  let num = len(getbufinfo({'buflisted':1}))
  let hid = len(filter(getbufinfo({'buflisted':1}), 'empty(v:val.windows)'))
  return hid ? num-hid."+".hid : num
endfunction
