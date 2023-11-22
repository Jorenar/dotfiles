fun s:TabsLineUp() abort " https://sharats.me/posts/automating-the-vim-workplace-3/#using-vartabstop-to-line-up
py3 <<EOPYTHON
import vim
lengths = []
for parts in (l.split('\t') for l in vim.current.buffer if '\t' in l):
    lengths.append([len(c) for c in parts])
vim.current.buffer.options['vartabstop'] = ','.join(str(max(ls) + 3) for ls in zip(*lengths))
EOPYTHON
endfun

" call <SID>TabsLineUp()

setlocal noexpandtab
