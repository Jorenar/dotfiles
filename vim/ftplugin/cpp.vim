if !g:enable_lsp
  setlocal tags+=$XDG_TAGS_DIR/cpp
  setlocal tags+=$XDG_TAGS_DIR/boost
endif

let OmniCpp_DefaultNamespaces = [ "std", "_GLIBCXX_STD", "_GLIBCXX_STD_A", "_GLIBCXX_STD_C", "::" ]
let OmniCpp_DisplayMode       = 1
let OmniCpp_NamespaceSearch   = 1
