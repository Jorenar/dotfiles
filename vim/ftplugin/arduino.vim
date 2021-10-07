runtime! ftplugin/cpp.vim

setlocal tabstop=2
setlocal tags+=$XDG_TAGS_DIR/arduino

SetFormatProg "uncrustify --l CPP base kr mb stroustrup 1tbs 2sw"
