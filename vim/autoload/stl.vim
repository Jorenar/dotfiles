function! stl#FileSize() abort
  let [ bytes, units, i ] = [ getfsize(expand(@%)), ['', 'Ki', 'Mi', 'Gi'], 0 ]
  while bytes >= 1024 | let bytes = bytes / 1024.0 | let i += 1 | endwhile
  return printf((i ? "~%.1f" : "%d")." %sB", bytes, units[i])
endfunction

function! stl#FfAndEnc() abort
  return &ff.";".(&fenc == "" ? &enc : &fenc).(&bomb ? ",B" : "")
endfunction

function! stl#IssuesCount() abort
  let errors   = len(filter(getqflist(), 'v:val.type == "E"'))
  let warnings = len(filter(getqflist(), 'v:val.type == "w"'))
  return errors."E ".warnings."w"
endfunction

function! stl#ModifBufs() abort
  let cnt = len(filter(getbufinfo(), 'v:val.changed'))
  return (&mod ? "[+". (cnt > 1 ? cnt : "") ."]" : "[".cnt."]")
endfunction

function! stl#NumOfBufs() abort
  let num = len(getbufinfo({'buflisted':1}))
  let hid = len(filter(getbufinfo({'buflisted':1}), 'empty(v:val.windows)'))
  return hid ? (num-hid)."+".hid : num
endfunction

if get(g:, "loaded_signify", 0) " VCS stats; requires Signify plugin
  function! stl#VcsStats() abort
    let sy = getbufvar(bufnr(), "sy")
    if empty(sy) | return "" | endif
    if !has_key(sy, "vcs") | return "" | endif
    let stats = map(sy.stats, 'v:val < 0 ? 0 : v:val')
    return printf("  [+%s -%s ~%s]", stats[0], stats[2], stats[1])
  endfunction
else
  function! stl#VcsStats() abort
    return "Sy: X"
  endfunction
endif
