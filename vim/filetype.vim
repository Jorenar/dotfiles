if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect

  au! BufRead,BufNewFile *.asm       setf nasm
  au! BufRead,BufNewFile *.conf      setf conf
  au! BufRead,BufNewFile *.csv       setf csv
  au! BufRead,BufNewFile *.fish      setf fish
  au! BufRead,BufNewFile *.h         setf c
  au! BufRead,BufNewFile *.list      setf conf
  au! BufRead,BufNewFile *.m3u       setf m3u
  au! BufRead,BufNewFile *.snippets  setf snippets
  au! BufRead,BufNewFile LICENSE     setf LICENSE

augroup END
