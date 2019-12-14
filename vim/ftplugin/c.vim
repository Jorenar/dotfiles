setlocal path+=/usr/include/**
setlocal tags+=$XDG_DATA_HOME/vim/tags/systags
setlocal foldmethod=syntax

nnoremap <silent> <expr> za foldlevel('.') <= 2 && index(map(synstack(line('.'), col('$')), 'synIDattr(v:val, "name")'), "cBlock2") ? (foldclosed('.') != -1 && foldlevel('.') == 1 ? ":normal! zozjzo\<CR>" : "2za") : 'za'
