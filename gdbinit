set print object on
set print pretty on
set print vtbl

set tui border-kind acs
set tui border-mode normal
set tui active-border-mode bold

set disassembly-flavor intel

set extended-prompt \[\e[1m\](gdb\[\e[0m\]:\f\[\e[1m\]) \[\e[0m\]
set prompt \033[1m(gdb) \033[0m

set history save on

python
import os
if 'XDG_HISTORY_DIR' in os.environ:
    gdb.execute('set history filename ' + os.environ['XDG_HISTORY_DIR'] + '/gdb')
end

# vim: ft=gdb
