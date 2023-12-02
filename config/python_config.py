import atexit
import os
import readline

histfile = os.path.join(os.environ["HISTORY_DIR"], "python")
try:
    readline.read_history_file(histfile)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)
