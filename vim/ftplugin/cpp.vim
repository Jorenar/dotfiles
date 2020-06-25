if !get(g:, "enable_lsp", 1)
  set tags+=$XDG_DATA_HOME/tags/cpp
  set tags+=$XDG_DATA_HOME/tags/boost

  let OmniCpp_DefaultNamespaces = [ "std", "_GLIBCXX_STD", "_GLIBCXX_STD_A", "_GLIBCXX_STD_C", "::" ]
  let OmniCpp_DisplayMode       = 1
  let OmniCpp_NamespaceSearch   = 1
endif
