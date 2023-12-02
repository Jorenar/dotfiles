runtime! ftplugin/cpp.vim
setlocal tabstop=2
SetFormatProg "uncrustify -l CPP -c " . $XDG_CONFIG_HOME."/uncrustify/langs/arduino.cfg"
