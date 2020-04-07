set extended-prompt \[\e[1m\](gdb\[\e[0m\]:\f\[\e[1m\]) \[\e[0m\]
set history save on
set print pretty on
set prompt \033[1m(gdb) \033[0m

python
import os
if 'XDG_HISTORY_DIR' in os.environ:
    gdb.execute('set history filename ' + os.environ['XDG_HISTORY_DIR'] + '/gdb')
end

# vim: ft=gdb
