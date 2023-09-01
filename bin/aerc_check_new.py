#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import os
import imaplib
import subprocess
import configparser

config = configparser.ConfigParser(interpolation=None)
config.read(os.path.join(os.environ["XDG_CONFIG_HOME"], "aerc", "accounts.conf"))

count = []
for section in config.sections():
    source = config[section]["source"]
    scheme, source = source.split("://")

    if not scheme.startswith("imap"):
        continue

    user, source = source.split('@')
    user = user.replace('%40', '@')
    source = source.split(':')

    host = source[0]
    port = 993 if len(source) == 1 else source[1]

    passcmd = config[section]["source-cred-cmd"]
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