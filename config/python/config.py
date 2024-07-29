import atexit
import os
import readline

histfile = os.path.join(os.environ["XDG_STATE_HOME"], "python_history")
try:
    readline.read_history_file(histfile)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)
