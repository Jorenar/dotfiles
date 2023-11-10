#!/usr/bin/env python3

import wx
import wx.adv

import os
import subprocess

TRAY_TOOLTIP = 'Detached Tmux sessions'
TRAY_ICON = os.path.dirname(__file__) + '/logo.png'
TMUX_LS = r"tmux ls -F '#{session_name}: #W | #T' -f '#{?session_attached,0,1}'"


class TaskBarIcon(wx.adv.TaskBarIcon):
    def __init__(self):
        super(TaskBarIcon, self).__init__()
        self.SetIcon(wx.Icon(TRAY_ICON), TRAY_TOOLTIP)
        self.Bind(wx.adv.EVT_TASKBAR_LEFT_DOWN, self.on_left_down)

    def on_left_down(self, event):
        self.PopupMenu(self.CreatePopupMenu())

    def CreatePopupMenu(self):
        sessions = os.popen(TMUX_LS).read()
        if not sessions:
            return

        menu = wx.Menu()
        for session in sessions.strip().split('\n'):
            label = session.strip()
            item = wx.MenuItem(menu, -1, label)
            menu.Bind(wx.EVT_MENU,
                      lambda _: self.open(label.split(':')[0]),
                      id=item.GetId())
            menu.Append(item)
        return menu

    def open(self, session):
        subprocess.Popen(f"xterm -e 'tmux attach -t {session}'",
                         shell=True, start_new_session=True)


class App(wx.App):
    def OnInit(self):
        self.SetTopWindow(wx.Frame(None))
        TaskBarIcon()
        return True


App(False).MainLoop()
