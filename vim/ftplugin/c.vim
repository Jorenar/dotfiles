setlocal path+=/usr/include/**
setlocal tags+=$XDG_DATA_HOME/vim/tags/systags
setlocal foldmethod=syntax

"nnoremap <silent> <expr> za foldlevel('.') <= 3 && index(map(synstack(line('.'), col('$')), 'synIDattr(v:val, "name")'), "cFunc") ? (foldclosed('.') != -1 && foldlevel('.') == 1 ? ":normal! zozjzok\<CR>" : "2za") : 'za'
