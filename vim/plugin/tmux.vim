if ( &term =~ "screen" || &term =~ "xterm" )

  " window title fix
  if &t_ts == ""
    let &t_ts = "\e]2;"
  endif

  MinPlug christoomey/vim-tmux-navigator

endif
