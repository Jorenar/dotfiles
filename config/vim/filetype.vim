if exists("did_load_filetypes") | finish | endif
augroup filetypedetect
  let g:asmsyntax = "nasm"
  let g:filetype_cfg = "conf"
  let g:c_syntax_for_h = 1

  au! BufRead,BufNewFile *.gradle      setf gradle
  au! BufRead,BufNewFile *.snippets    setf snippets
  au! BufRead,BufNewFile */ssh/config  setf sshconfig
  au! BufRead,BufNewFile LICENSE       setf LICENSE
  au! BufRead,BufNewFile ~/.todo       setf todo

  " au! FileType conf
  "       \   if search('^\[\a\+\]')
  "       \ |   setf dosini
  "       \ | else
  "       \ |   setf conf
  "       \ | endif

augroup END
