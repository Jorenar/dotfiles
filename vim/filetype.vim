if exists("did_load_filetypes") | finish | endif

augroup filetypedetect
  let g:c_syntax_for_h = 1

  au! BufRead,BufNewFile *.asm       setf nasm
  au! BufRead,BufNewFile *.csv       setf csv
  au! BufRead,BufNewFile *.fish      setf fish
  au! BufRead,BufNewFile *.list      setf conf
  au! BufRead,BufNewFile *.m3u       setf m3u
  au! BufRead,BufNewFile *.snippets  setf snippets
  au! BufRead,BufNewFile ~/.todo     setf todo
  au! BufRead,BufNewFile LICENSE     setf LICENSE

  au! BufRead,BufNewFile *.conf
        \   if search('^\[\a\+\]')
        \ |   setf dosini
        \ | else
        \ |   setf conf
        \ | endif

augroup END
