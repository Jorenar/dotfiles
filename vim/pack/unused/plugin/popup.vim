nnoremenu PopUp.[gd] gd
nnoremenu PopUp.:call :popup ]call<CR>
nnoremenu ]call.popup_clear() :call popup_clear()<CR>

nnoremenu PopUp.:grep :silent! grep -RIw <cword> .<CR>


nnoremenu PopUp.LSP :popup ]LSP<CR>
nnoremenu ]LSP.Hover       <Plug>(lsp-hover)
nnoremenu ]LSP.Call\ Tree  :LspCallHierarchyIncomingTree<CR>
nnoremenu ]LSP.[Peek]\ Definition  <Plug>(lsp-peek-definition)
nnoremenu ]LSP.[Peek]\ Declaration <Plug>(lsp-peek-declaration)
nnoremenu ]LSP.[Jump]\ Definition  <Plug>(lsp-definition)
nnoremenu ]LSP.[Jump]\ Declaration <Plug>(lsp-declaration)
