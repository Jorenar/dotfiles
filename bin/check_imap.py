#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import os
import imaplib
import subprocess
import configparser

config = configparser.ConfigParser(interpolation=None)
config.read(os.path.join(os.environ["XDG_CONFIG_HOME"], "check_imap.ini"))

count = []
for section in config.sections():
    acc = config[section]

    user = acc["user"]
    host = acc["host"]

    port = acc["port"] if "port" in acc else 993

    passcmd = acc["passcmd"]
    passwd = None
    try:
        passwd = subprocess.check_output(passcmd, shell=True, timeout=1)
        passwd = passwd.decode("UTF-8").strip()
    except subprocess.TimeoutExpired:
        continue

    try:
        box = imaplib.IMAP4_SSL(host, port)
        box.login(user, passwd)
        box.select()
        _, ids = box.search(None, 'UNSEEN')
        box.logout()
        count.append(str(len(ids[0].split())))
    except imaplib.IMAP4.error:
        count.append("x")

print(",".join(count))
