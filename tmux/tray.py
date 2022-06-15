#!/usr/bin/env python3

import gi
import os
import signal
import subprocess
import time

from threading import Thread

gi.require_version('Gtk', '3.0')
try:
    gi.require_version('AppIndicator3', '0.1')
except ValueError:
    exit(0)

from gi.repository import Gtk, AppIndicator3


class Indicator():
    tmux_ls = r"tmux ls -F '#{session_name}: #W' -f '#{?session_attached,0,1}'"

    def __init__(self):
        self.indicator = AppIndicator3.Indicator.new(
            "tmux-tray-indicator",
            os.path.join(os.path.dirname(__file__), "logo.png"),
            AppIndicator3.IndicatorCategory.OTHER
        )
        self.indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)

        self.update = Thread(target=self.update_menu, daemon=True)
        self.update.start()

    def create_menu(self):
        sessions = os.popen(self.tmux_ls).read()

        menu = Gtk.Menu()

        if not sessions:
            item = Gtk.MenuItem(label="No detached sessions")
            menu.append(item)
        else:
            for session in sessions.strip().split('\n'):
                item = Gtk.MenuItem(label=session.strip())
                item.connect('activate', self.open)
                menu.append(item)

        menu.show_all()
        self.indicator.set_menu(menu)

    def update_menu(self):
        while True:
            time.sleep(3)
            self.create_menu()

    def open(self, item):
        session = item.get_label().split(':')[0]
        subprocess.Popen(f"xterm -e 'tmux attach -t {session}'",
                         shell=True, start_new_session=True)

    def stop(self, source=None):
        Gtk.main_quit()


Indicator()
signal.signal(signal.SIGINT, signal.SIG_DFL)
Gtk.main()
