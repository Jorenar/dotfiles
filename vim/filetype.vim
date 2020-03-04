if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect

  au! BufRead,BufNewFile *.asm       setf nasm      runtime! indent/asm.vim
  au! BufRead,BufNewFile *.conf      setf conf
  au! BufRead,BufNewFile *.h         setf c
  au! BufRead,BufNewFile *.list      setf conf
  au! BufRead,BufNewFile *.snippets  setf snippets
  au! BufRead,BufNewFile LICENSE     setf LICENSE

augroup END
