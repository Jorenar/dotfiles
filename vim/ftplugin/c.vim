setlocal path+=/usr/include/**
setlocal tags+=$XDG_DATA_HOME/vim/tags/systags
setlocal foldmethod=syntax

nnoremap <expr> za foldlevel('.') == 2 && index(map(synstack(line('.'), col('$')), 'synIDattr(v:val, "name")'), "cBlock2") ? "2za" : 'za'
