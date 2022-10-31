set print object on
set print pretty on
set print vtbl

set disassembly-flavor intel

set tui border-kind acs
set tui border-mode normal
set tui active-border-mode bold

tui new-layout example {-horizontal src 1 asm 1} 2 status 0 cmd 1
# layout example
# focus cmd

#set prompt \033[1m(gdb) \033[0m

set history save on

python
import os
if 'XDG_HISTORY_DIR' in os.environ:
    gdb.execute('set history filename ' + os.environ['XDG_HISTORY_DIR'] + '/gdb')
end

# vim: ft=gdb
