if exists("did_load_filetypes") | finish | endif

command! -nargs=1  SetFormatProg
      \ exec {prg -> 'let [ &l:fp, &l:fex ] = [ "'.prg.' 2> /dev/null", "" ]'}(<args>)

augroup filetypedetect
  let g:asmsyntax = "nasm"
  let g:filetype_cfg = "conf"
  let g:c_syntax_for_h = 1

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
