runtime! ftplugin/cpp.vim

setlocal tabstop=2
setlocal tags+=$XDG_TAGS_DIR/arduino

SetFormatProg "uncrustify -l CPP -c " . $XDG_CONFIG_HOME."/uncrustify/langs/arduino.cfg"
